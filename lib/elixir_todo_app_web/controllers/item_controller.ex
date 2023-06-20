defmodule ElixirTodoAppWeb.ItemController do
  use ElixirTodoAppWeb, :controller
  alias ElixirTodoApp.{Items, Lists}

  def index(conn, %{"list_id" => list_id}) do
    items = Items.list_all(list_id)

    conn
    |> put_resp_content_type("application/json")
    |> json(%{items: items})
  end

  def create(conn, %{"list_id" => list_id, "item" => item_params}) do
    list = Lists.get_list(list_id)

    cond do
      is_nil(list) ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "No such list exists"})

      list.archived ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "List is archived, can't create an item in it"})

      true ->
        case Items.create_item(list_id, item_params) do
          {:ok, item} ->
            conn
            |> put_status(:created)
            |> json(%{item: item})

          {:error, changeset} ->
            conn
            |> put_resp_content_type("application/json")
            |> json(%{message: "Unidentified error"})
        end
    end
  end

  def update(conn, %{"list_id" => list_id, "id" => id, "item" => item_params} = params) do
    item = Items.get_item(id)
    list = Lists.get_list(list_id)

    cond do
      is_nil(list) ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "No such list exists"})

      is_nil(item) ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "No such item exists"})

      list.archived ->
        conn
        |> put_resp_content_type("application/json")
        |> json(%{message: "List is archived, can't update any item"})

      true ->
        case Items.update_item(item, item_params) do
          {:ok, updated_item} ->
            conn
            |> put_status(:ok)
            |> json(%{item: updated_item})

          {:error, changeset} ->
            conn
            |> put_resp_content_type("application/json")
            |> json(%{message: "Unidentified error"})
        end
    end
  end
end
