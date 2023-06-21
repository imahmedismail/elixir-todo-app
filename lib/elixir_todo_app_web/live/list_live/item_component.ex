defmodule ElixirTodoAppWeb.ListLive.ItemComponent do
  use ElixirTodoAppWeb, :live_component
  import ElixirTodoAppWeb.Utils

  alias ElixirTodoApp.{Items, HttpoisonClient}

  @items_base_url "http://localhost:4000/api/lists"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage item records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="item-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:completed]} type="checkbox" label="Is Completed? (OPTIONAL)" />
        <.input field={@form[:todo_list_id]} type="hidden" value={@list.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Items.change_item(item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item
      |> Items.change_item(item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"item" => item_params}, socket) do
    save_item(socket, socket.assigns.action, item_params)
  end

  defp save_item(socket, :edit_item, item_params) do
    case HttpoisonClient.patch_request(
           @items_base_url <>
             "/#{socket.assigns.item.todo_list_id}/items/#{socket.assigns.item.id}",
           %{
             "item" => item_params
           }
         )
         |> Jason.decode!() do
      %{"message" => "List is archived, can't update any item"} = response ->
        {:noreply,
         socket
         |> put_flash(:error, response["message"])
         |> push_patch(to: socket.assigns.patch)}

      %{"item" => item} ->
        item = convert_map(item)
        notify_parent({:saved_item, item})
        notify_parent({:saved_list, socket.assigns.list})

        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_item(socket, :new_item, item_params) do
    case HttpoisonClient.post_request(@items_base_url <> "/#{socket.assigns.list.id}/items", %{
           "item" => item_params
         })
         |> Jason.decode!() do
      %{"message" => "List is archived, can't create an item in it"} = response ->
        notify_parent({:saved_list, socket.assigns.list})

        {:noreply,
         socket
         |> put_flash(:error, response["message"])
         |> push_patch(to: socket.assigns.patch)}

      %{"item" => item} ->
        item = convert_map(item)
        notify_parent({:saved_item, item})
        notify_parent({:saved_list, socket.assigns.list})

        {:noreply,
         socket
         |> put_flash(:info, "Item created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
