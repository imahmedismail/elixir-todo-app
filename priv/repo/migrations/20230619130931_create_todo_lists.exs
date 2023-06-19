defmodule ElixirTodoApp.Repo.Migrations.CreateTodoLists do
  use Ecto.Migration

  def change do
    create table(:todo_lists) do
      add :title, :string
      add :archived, :boolean, default: false
      timestamps()
    end
  end
end
