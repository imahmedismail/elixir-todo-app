defmodule ElixirTodoApp.ListsTest do
  use ElixirTodoApp.DataCase

  alias ElixirTodoApp.{List, Lists, Repo}

  @invalid_id 22_11_44

  describe "list_all/0 action" do
    test "returns the lists of all todo-list" do
      Repo.insert(%List{title: "List 1"})
      Repo.insert(%List{title: "List 2"})

      assert Lists.list_all() |> Enum.count() == 2
    end

    test "returns [], if no items exists" do
      assert Lists.list_all() == []
    end
  end

  describe "get_list/1 action" do
    test "returns the list against valid id" do
      {:ok, list} = Repo.insert(%List{title: "My List"})

      assert Lists.get_list(list.id).title == "My List"
    end

    test "returns nil against any invalid id" do
      Repo.insert(%List{title: "My List"})

      assert Lists.get_list(@invalid_id) == nil
    end
  end

  describe "create_list/1 action" do
    test "creates a todo-list" do
      assert {:ok, _} = Lists.create_list(%{title: "List 1"})
    end

    test "throws an error if empty map attributes are passed to it" do
      assert {:error, _} = Lists.create_list(%{})
    end
  end

  describe "update_list/2 action" do
    test "updates an item against any todo-list" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      assert {:ok, _} = Lists.update_list(list, %{title: "List 2"})
    end

    test "do nothing, if an empty attributes map is passed to it" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      assert {:ok, _} = Lists.update_list(list, %{})
    end
  end
end
