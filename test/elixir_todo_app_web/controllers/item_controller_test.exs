defmodule ElixirTodoAppWeb.ItemControllerTest do
  use ElixirTodoAppWeb.ConnCase
  alias ElixirTodoAppWeb.ItemController
  alias ElixirTodoApp.{List, Repo, Item}

  @invalid_id 22_33_11

  describe "index/2 action of item-controller" do
    test "lists all the todo-items from database", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      Repo.insert(%Item{content: "Item1", todo_list_id: list.id})
      Repo.insert(%Item{content: "Item2", todo_list_id: list.id})
      Repo.insert(%Item{content: "Item3", todo_list_id: list.id})

      response = ItemController.index(conn, %{"list_id" => list.id}).resp_body |> Jason.decode!()
      assert response["items"] |> Enum.count() == 3
    end

    test "returns [] if no result exists", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      response = ItemController.index(conn, %{"list_id" => list.id}).resp_body |> Jason.decode!()
      assert response["items"] |> Enum.count() == 0
    end
  end

  describe "create/2 action of item-controller" do
    test "creates the todo-item", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})

      response =
        ItemController.create(conn, %{
          "list_id" => list.id,
          "item" => %{"content" => "Item1", "todo_list_id" => list.id}
        }).resp_body
        |> Jason.decode!()

      assert response["item"]["content"] == "Item1"
    end

    test "with empty-params throws unidentified error", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})

      response =
        ItemController.create(conn, %{"list_id" => list.id, "item" => %{}}).resp_body
        |> Jason.decode!()

      assert response["message"] == "Unidentified error"
    end

    test "throws error if invalid list-id is passed", %{conn: conn} do
      Repo.insert(%List{title: "List 1"})

      response =
        ItemController.create(conn, %{"list_id" => @invalid_id, "item" => %{}}).resp_body
        |> Jason.decode!()

      assert response["message"] == "No such list exists"
    end

    test "can't create an item in archived list", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1", archived: true})

      response =
        ItemController.create(conn, %{
          "list_id" => list.id,
          "item" => %{"content" => "test", "todo_list_id" => list.id}
        }).resp_body
        |> Jason.decode!()

      assert response["message"] == "List is archived, can't create an item in it"
    end
  end

  describe "update/2 action of item-controller" do
    test "updates the item", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      {:ok, item} = Repo.insert(%Item{content: "List 1", todo_list_id: list.id})

      response =
        ItemController.update(conn, %{
          "list_id" => list.id,
          "id" => item.id,
          "item" => %{"content" => "Updated Content"}
        }).resp_body
        |> Jason.decode!()

      assert response["item"]["content"] == "Updated Content"
    end

    test "with empty params do nothing", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      {:ok, item} = Repo.insert(%Item{content: "List 1", todo_list_id: list.id})

      response =
        ItemController.update(conn, %{"list_id" => list.id, "id" => item.id, "item" => %{}}).resp_body
        |> Jason.decode!()

      assert response["item"]["content"] == "List 1"
    end

    test "with invalid list-id returns error", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      {:ok, item} = Repo.insert(%Item{content: "List 1", todo_list_id: list.id})

      response =
        ItemController.update(conn, %{"list_id" => @invalid_id, "id" => item.id, "item" => %{}}).resp_body
        |> Jason.decode!()

      assert response["message"] == "No such list exists"
    end

    test "with invalid item-id returns error", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1"})
      Repo.insert(%Item{content: "List 1", todo_list_id: list.id})

      response =
        ItemController.update(conn, %{"list_id" => list.id, "id" => @invalid_id, "item" => %{}}).resp_body
        |> Jason.decode!()

      assert response["message"] == "No such item exists"
    end

    test "can't update the item-content of archived list", %{conn: conn} do
      {:ok, list} = Repo.insert(%List{title: "List 1", archived: true})
      {:ok, item} = Repo.insert(%Item{content: "List 1", todo_list_id: list.id})

      response =
        ItemController.update(conn, %{
          "list_id" => list.id,
          "id" => item.id,
          "item" => %{"content" => "trying to update"}
        }).resp_body
        |> Jason.decode!()

      assert response["message"] == "List is archived, can't update any item"
    end
  end
end
