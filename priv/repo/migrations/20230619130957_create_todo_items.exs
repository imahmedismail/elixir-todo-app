defmodule ElixirTodoApp.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items) do
      add :content, :string
      add :completed, :boolean, default: false
      add :todo_list_id, references(:todo_lists, on_delete: :nothing)
      timestamps()
    end

    create index(:todo_items, [:todo_list_id])
  end
end
