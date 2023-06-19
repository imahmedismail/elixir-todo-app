defmodule ElixirTodoAppWeb.ItemJSON do
  def render("index.json", %{items: items}) do
    %{data: Enum.map(items, &render_item/1)}
  end

  def render("show.json", %{item: item}) do
    %{data: render_item(item)}
  end

  def render_item(item) do
    %{
      "id" => item.id,
      "todo_list_id" => item.todo_list_id,
      "content" => item.content,
      "completed" => item.completed,
      "inserted_at" => item.inserted_at,
      "updated_at" => item.updated_at
    }
  end
end
