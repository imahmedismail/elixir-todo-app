defmodule ElixirTodoApp.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_lists" do
    field :title, :string
    field :archived, :boolean, default: false
    timestamps()
  end

  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title])
  end
end
