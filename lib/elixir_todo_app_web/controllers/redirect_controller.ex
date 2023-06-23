defmodule ElixirTodoAppWeb.RedirectController do
  use ElixirTodoAppWeb, :controller

  def index(conn, _params \\ %{}),
    do:
      conn
      |> redirect(to: "/todo/list")
end
