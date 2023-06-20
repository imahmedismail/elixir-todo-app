defmodule ElixirTodoApp.Items do
  alias ElixirTodoApp.{Repo, Item}
  alias ElixirTodoApp.Lists
  import Ecto.Query

  def list_all(todo_list_id) do
   from(item in Item, where: item.todo_list_id == ^todo_list_id)
   |> Repo.all()
  end

  def get_item(id) do
    Repo.get(Item, id)
  end

  def create_item(todo_list_id, attrs) do
    Lists.get_list(todo_list_id)
    |> build_item(attrs)
    |> Repo.insert()
  end

  def update_item(item, attrs) do
    Item.changeset(item, attrs)
    |> Repo.update()
  end

  defp build_item(list, attrs) do
    %Item{todo_list_id: list.id}
    |> Item.changeset(attrs)
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
