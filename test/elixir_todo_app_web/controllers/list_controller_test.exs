defmodule ElixirTodoAppWeb.ListControllerTest do
  use ElixirTodoAppWeb.ConnCase
  alias ElixirTodoApp.{List, Repo}

  @invalid_id 22_33_11

  test "index/2 action of list-controller lists all the todo-lists from database", %{conn: conn} do
    Repo.insert(%List{title: "List 1"})
    Repo.insert(%List{title: "List 2"})

    response = ElixirTodoAppWeb.ListController.index(conn).resp_body |> Jason.decode!()
    assert response["lists"] |> Enum.count() == 2
  end

  test "index/2 action of list-controller returns [] if no result exists", %{conn: conn} do
    response = ElixirTodoAppWeb.ListController.index(conn).resp_body |> Jason.decode!()
    assert response["lists"] |> Enum.count() == 0
  end

  test "create/2 action of list-controller creates the todo-list", %{conn: conn} do
    response =
      ElixirTodoAppWeb.ListController.create(conn, %{"list" => %{"title" => "dummy list"}}).resp_body
      |> Jason.decode!()

    assert response["list"]["title"] == "dummy list"
  end

  test "create/2 action of list-controller with empty-params", %{conn: conn} do
    response =
      ElixirTodoAppWeb.ListController.create(conn, %{"list" => %{}}).resp_body |> Jason.decode!()

    assert response["message"] == "Unidentified error"
  end

  test "update/2 action of list-controller updates the list", %{conn: conn} do
    {:ok, list} = Repo.insert(%List{title: "List 1"})

    response =
      ElixirTodoAppWeb.ListController.update(conn, %{
        "id" => list.id,
        "list" => %{"title" => "Updated Title"}
      }).resp_body
      |> Jason.decode!()

    assert response["list"]["title"] == "Updated Title"
  end

  test "update/2 action of list-controller with empty params do nothing", %{conn: conn} do
    {:ok, list} = Repo.insert(%List{title: "List 1"})

    response =
      ElixirTodoAppWeb.ListController.update(conn, %{"id" => list.id, "list" => %{}}).resp_body
      |> Jason.decode!()

    assert response["list"]["title"] == "List 1"
  end

  test "update/2 action of list-controller with invalid list-id returns error", %{conn: conn} do
    response =
      ElixirTodoAppWeb.ListController.update(conn, %{"id" => @invalid_id, "list" => %{}}).resp_body
      |> Jason.decode!()

    assert response["message"] == "No such list exists"
  end

  test "update/2 action of list-controller can't update the title of archived list", %{conn: conn} do
    {:ok, list} = Repo.insert(%List{title: "List 1", archived: true})

    response =
      ElixirTodoAppWeb.ListController.update(conn, %{
        "id" => list.id,
        "list" => %{"title" => "trying to update title"}
      }).resp_body
      |> Jason.decode!()

    assert response["message"] == "List is archived, can't update its title"
  end
end
