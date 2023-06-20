defmodule ElixirTodoAppWeb.ListLive.Show do
  use ElixirTodoAppWeb, :live_view
  import ElixirTodoAppWeb.Utils
  alias ElixirTodoApp.{Lists, TeslaClient}
  @item_base_url "http://localhost:4000/api/lists"

  @impl true
  def mount(%{"id" => list_id} = params, _session, socket) do
    response = TeslaClient.get_request(@item_base_url <> "/#{list_id}/items").body |> Jason.decode!()
    {:ok, stream(socket, :item_collection, response["items"] |> convert_list_of_maps())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:list, Lists.get_list(id))}
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
end
