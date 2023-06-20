defmodule ElixirTodoApp.Cleanup do
  use GenServer
  alias ElixirTodoApp.{List, Repo}
  import Ecto.Query

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # This will run after 5 minute, and will perform the desired task
    :timer.send_interval(300_000, :work)
    {:ok, state}
  end

  def handle_info(:work, state) do
    cutoff_time = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(list in List,
      where: not is_nil(list.updated_at) and list.updated_at <= ^cutoff_time and not list.archived
    )
    |> Repo.update_all(set: [archived: true])

    {:noreply, state}
  end
end
