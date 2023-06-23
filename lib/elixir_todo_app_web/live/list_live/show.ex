defmodule ElixirTodoAppWeb.ListLive.Show do
  use ElixirTodoAppWeb, :live_view
  import ElixirTodoAppWeb.Utils
  alias ElixirTodoApp.{Item, Items, Lists, TeslaClient}
  @item_base_url "http://localhost:4000/api/lists"

  @impl true
  def mount(%{"id" => list_id} = _params, _session, socket) do
    response =
      TeslaClient.get_request(@item_base_url <> "/#{list_id}/items").body |> Jason.decode!()

    {:ok, stream(socket, :item_collection, response["items"] |> convert_list_of_maps())}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({ElixirTodoAppWeb.ListLive.ItemComponent, {:saved_list, list}}, socket) do
    {:noreply, assign(socket, :list, list)}
  end

  @impl true
  def handle_info({ElixirTodoAppWeb.ListLive.ItemComponent, {:saved_item, item}}, socket) do
    {:noreply, stream_insert(socket, :item_collection, item)}
  end

  @impl true
  def handle_info({ElixirTodoAppWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, assign(socket, :list, list)}
  end

  defp apply_action(socket, :new_item, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :edit_item, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Items.get_item(id))
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Items Listing")
    |> assign(:list, Lists.get_list(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Lists.get_list(id))
  end
end
