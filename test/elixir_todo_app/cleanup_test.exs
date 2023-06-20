defmodule ElixirTodoApp.CleanupTest do
  use ElixirTodoApp.DataCase
  alias ElixirTodoApp.{List, Repo}
  import Ecto.Query

  setup do
    updated_at =
      Timex.shift(Timex.now(), days: -2)
      |> Timex.to_naive_datetime()
      |> NaiveDateTime.truncate(:second)

    inserted_at = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    todo_lists = [
      %{
        id: 1,
        title: "List 1",
        archived: false,
        inserted_at: inserted_at,
        updated_at: updated_at
      },
      %{
        id: 2,
        title: "List 2",
        archived: false,
        inserted_at: inserted_at,
        updated_at: inserted_at
      },
      %{id: 3, title: "List 3", archived: true, inserted_at: inserted_at, updated_at: updated_at},
      %{id: 4, title: "List 4", archived: false, inserted_at: inserted_at, updated_at: updated_at}
    ]

    ElixirTodoApp.Repo.insert_all(ElixirTodoApp.List, todo_lists)

    {:ok, todo_lists: todo_lists}
  end

  test "todo-cleanup archives unarchived Todo lists not updated in the last 24 hours", %{
    todo_lists: todo_lists
  } do
    mock_cleanup_functionality()
    assert todo_lists != ElixirTodoApp.Repo.all(ElixirTodoApp.List)

    assert Enum.filter(ElixirTodoApp.Repo.all(ElixirTodoApp.List), fn list ->
             list.archived == true
           end)
           |> Enum.count() == 3
  end

  defp mock_cleanup_functionality() do
    cutoff_time = DateTime.utc_now() |> DateTime.add(-24, :hour)

    from(list in List,
      where: not is_nil(list.updated_at) and list.updated_at <= ^cutoff_time and not list.archived
    )
    |> Repo.update_all(set: [archived: true])
  end
end
