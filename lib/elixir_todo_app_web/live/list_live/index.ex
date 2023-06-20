defmodule ElixirTodoAppWeb.ListLive.Index do
  use ElixirTodoAppWeb, :live_view
  import ElixirTodoAppWeb.Utils

  alias ElixirTodoApp.{Lists, List, TeslaClient}
  @lists_base_url "http://localhost:4000/api/lists"

  @impl true
  def mount(_params, _session, socket) do
    response = TeslaClient.get_request(@lists_base_url).body |> Jason.decode!()
    {:ok, stream(socket, :list_collection, response["lists"] |> convert_list_of_maps())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Lists.get_list(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing List")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({ElixirTodoAppWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :list_collection, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = Lists.get_list!(id)
    {:ok, _} = Lists.delete_list(list)

    {:noreply, stream_delete(socket, :list_collection, list)}
  end
end
