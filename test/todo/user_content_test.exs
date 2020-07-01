defmodule Todo.UserContentTest do
  use Todo.DataCase

  alias Todo.UserContent
  alias Todo.Accounts.User

  describe "todolists" do
    alias Todo.UserContent.Todolist

    @user %User{id: 1, username: "some username", password_hash: "some password_hash"}
    @valid_attrs %{event_date: "2010-04-17T14:00:00Z", title: "some title"}
    @update_attrs %{event_date: "2011-05-18T15:01:01Z", title: "some updated title"}
    @invalid_attrs %{event_date: nil, title: nil}

    def todolist_fixture(attrs \\ %{}) do
      attrs = attrs |> Enum.into(@valid_attrs)
      {:ok, todolist} = UserContent.create_todolist(@user, attrs)
      todolist
    end

    test "list_todolists/0 returns all todolists" do
      todolist = todolist_fixture()
      assert UserContent.list_todolists(@user) == [todolist]
    end

    test "get_todolist!/1 returns the todolist with given id" do
      todolist = todolist_fixture()
      assert UserContent.get_todolist(@user, todolist.id) == todolist
    end

    test "create_todolist/1 with valid data creates a todolist" do
      assert {:ok, %Todolist{} = todolist} = UserContent.create_todolist(@user, @valid_attrs)
      assert todolist.event_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert todolist.title == "some title"
    end

    test "create_todolist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContent.create_todolist(@user, @invalid_attrs)
    end

    test "update_todolist/2 with valid data updates the todolist" do
      todolist = todolist_fixture()
      assert {:ok, %Todolist{} = todolist} = UserContent.update_todolist(todolist, @update_attrs)
      assert todolist.event_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert todolist.title == "some updated title"
    end

    test "update_todolist/2 with invalid data returns error changeset" do
      todolist = todolist_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContent.update_todolist(todolist, @invalid_attrs)
      assert todolist == UserContent.get_todolist(@user, todolist.id)
    end

    test "delete_todolist/1 deletes the todolist" do
      todolist = todolist_fixture()
      assert {:ok, %Todolist{}} = UserContent.delete_todolist(@user, todolist)
      assert {:error, :not_found} = UserContent.get_todolist(@user, todolist.id)
    end
  end
end
