defmodule ElixirTodoAppWeb.ListLive.FormComponent do
  use ElixirTodoAppWeb, :live_component
  import ElixirTodoAppWeb.Utils

  alias ElixirTodoApp.{Lists, HttpoisonClient}

  @lists_base_url "http://localhost:4000/api/lists"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage list records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:archived]} type="checkbox" label="Archived" />
        <:actions>
          <.button phx-disable-with="Saving...">Save List</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{list: list} = assigns, socket) do
    changeset = Lists.change_list(list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"list" => list_params}, socket) do
    changeset =
      socket.assigns.list
      |> Lists.change_list(list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    case HttpoisonClient.patch_request(@lists_base_url <> "/#{socket.assigns.list.id}", %{
           "list" => list_params
         })
         |> Jason.decode!() do
      %{"message" => "List is archived, can't update its title"} = response ->
        {:noreply,
         socket
         |> put_flash(:error, response["message"])
         |> push_patch(to: socket.assigns.patch)}

      %{"list" => list} ->
        list = convert_map(list)
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_list(socket, :new, list_params) do
    case HttpoisonClient.post_request(@lists_base_url, %{"list" => list_params})
         |> Jason.decode!() do
      %{"list" => list} ->
        list = convert_map(list)
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
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
