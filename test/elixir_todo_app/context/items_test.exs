defmodule ElixirTodoApp.ItemsTest do
  use ElixirTodoApp.DataCase

  alias ElixirTodoApp.{List, Item, Items, Repo}

  @invalid_id 22_11_44

  describe "list_all/1 action" do
    test "returns the items of any todo-list" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      Repo.insert(%Item{content: "My List Item", todo_list_id: list.id})

      assert Items.list_all(list.id) |> Enum.count() == 1
    end

    test "returns [], if no items exists" do
      {:ok, list} = Repo.insert(%List{title: "My List"})

      assert Items.list_all(list.id) == []
    end
  end

  describe "get_item/1 action" do
    test "returns the item against valid id" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      {:ok, item} = Repo.insert(%Item{content: "My List Item", todo_list_id: list.id})

      assert Items.get_item(item.id).content == "My List Item"
    end

    test "returns nil against any invalid id" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      Repo.insert(%Item{content: "My List Item", todo_list_id: list.id})

      assert Items.get_item(@invalid_id) == nil
    end
  end

  describe "create_item/2 action" do
    test "creates an item against any todo-list" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      assert {:ok, _} = Items.create_item(list.id, %{content: "List 1"})
    end

    test "throws an error if empty map attributes are passed to it" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      assert {:error, _} = Items.create_item(list.id, %{})
    end
  end

  describe "update_item/2 action" do
    test "updates an item against any todo-list" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      {:ok, item} = Repo.insert(%Item{content: "My List Item", todo_list_id: list.id})
      assert {:ok, _} = Items.update_item(item, %{content: "List 1"})
    end

    test "do nothing, if an empty attributes map is passed to it" do
      {:ok, list} = Repo.insert(%List{title: "My List"})
      {:ok, item} = Repo.insert(%Item{content: "My List Item", todo_list_id: list.id})
      assert {:ok, _} = Items.update_item(item, %{})
    end
  end
end
