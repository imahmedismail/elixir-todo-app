defmodule ElixirTodoAppWeb.ListJSON do
  def render("message.json", %{message: message}) do
    %{message: message}
  end

  def render("index.json", %{lists: lists}) do
    %{data: Enum.map(lists, &render_list/1)}
  end

  def render("show.json", %{list: list}) do
    %{data: render_list(list)}
  end

  def render_list(list) do
    %{
      "id" => list.id,
      "title" => list.title,
      "archived" => list.archived,
      "inserted_at" => list.inserted_at,
      "updated_at" => list.updated_at
    }
  end
end
