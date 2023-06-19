defmodule ElixirTodoApp.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_items" do
    field :content, :string
    field :completed, :boolean, default: false
    field :todo_list_id, :integer
    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :todo_list_id, :completed])
    |> validate_required([:content, :todo_list_id])
  end
end
