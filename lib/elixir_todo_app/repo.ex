defmodule ElixirTodoApp.Repo do
  use Ecto.Repo,
    otp_app: :elixir_todo_app,
    adapter: Ecto.Adapters.Postgres
end
