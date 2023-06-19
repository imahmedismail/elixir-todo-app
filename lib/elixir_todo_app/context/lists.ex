defmodule ElixirTodoApp.Lists do
  alias ElixirTodoApp.{Repo, List}

  def list_all do
    Repo.all(List)
  end

  def get_list(id) do
    Repo.get(List, id)
  end

  def create_list(attrs) do
    List.changeset(%List{}, attrs)
    |> Repo.insert()
  end

  def update_list(list, attrs) do
    List.changeset(list, attrs)
    |> Repo.update()
  end
end
