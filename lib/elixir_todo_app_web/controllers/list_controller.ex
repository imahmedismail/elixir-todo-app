defmodule ElixirTodoAppWeb.ListController do
  use ElixirTodoAppWeb, :controller
  alias ElixirTodoApp.Lists

  def index(conn, _params) do
    lists = Lists.list_all()
    render(conn, "index.json", lists: lists)
  end

  def create(conn, %{"list" => list_params}) do
    case Lists.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_status(:created)
        |> render("show.json", list: list)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list(id)

    case Lists.update_list(list, list_params) do
      {:ok, updated_list} ->
        conn
        |> put_status(:ok)
        |> render("show.json", list: updated_list)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
