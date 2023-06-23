defmodule ElixirTodoApp.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :content, :completed, :todo_list_id, :inserted_at, :updated_at]}

  schema "todo_items" do
    field :content, :string
    field :completed, :boolean, default: false

    belongs_to :todo_lists, ElixirTodoApp.Item, foreign_key: :todo_list_id
    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :todo_list_id, :completed])
    |> validate_required([:content, :todo_list_id])
  end
end
