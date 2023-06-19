defmodule ElixirTodoAppWeb.ItemController do
  use ElixirTodoAppWeb, :controller
  alias ElixirTodoApp.{Items, Lists}

  def index(conn, %{"list_id" => list_id}) do
    items = Items.list_all(list_id)
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"list_id" => list_id, "item" => item_params}) do
    list = Lists.get_list(list_id)

    if list.archived do
      conn
      |> render("message.json", message: "List is archived, can't create an item in it")
    else
      case Items.create_item(list_id, item_params) do
        {:ok, item} ->
          conn
          |> put_status(:created)
          |> render("show.json", item: item)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", changeset: changeset)
      end
    end
  end

  def update(conn, %{"list_id" => list_id, "id" => id, "item" => item_params} = params) do
    item = Items.get_item(id)
    list = Lists.get_list(list_id)

    if list.archived do
      conn
      |> render("message.json", message: "List is archived, can't update any item")
    else
      case Items.update_item(item, item_params) do
        {:ok, updated_item} ->
          conn
          |> put_status(:ok)
          |> render("show.json", item: updated_item)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", changeset: changeset)
      end
    end
  end
end
