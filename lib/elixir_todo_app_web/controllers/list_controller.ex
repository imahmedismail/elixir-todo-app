defmodule ElixirTodoAppWeb.ListController do
  use ElixirTodoAppWeb, :controller
  alias ElixirTodoApp.{Lists, List}

  def index(conn, _params \\ %{}) do
    lists = Lists.list_all()

    conn
    |> put_resp_content_type("application/json")
    |> json(%{lists: lists})
  end

  def create(conn, %{"list" => list_params}) do
    case Lists.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{list: list})

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "Unidentified error"})
    end
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list(id)
    cond do
      is_nil(list) ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "No such list exists"})

      not is_nil(list) and list.archived and list_params["title"] ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "List is archived, can't update its title"})

      true ->
        case Lists.update_list(list, list_params) do
          {:ok, updated_list} ->
            conn
            |> put_resp_content_type("application/json")
            |> json(%{list: updated_list})

          {:error, changeset} ->
            conn
            |> put_resp_content_type("application/json")
            |> json(%{message: "Unidentified error"})
        end
    end
  end
end
