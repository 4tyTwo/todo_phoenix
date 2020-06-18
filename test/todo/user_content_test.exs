defmodule Todo.UserContentTest do
  use Todo.DataCase

  alias Todo.UserContent

  describe "todolists" do
    alias Todo.UserContent.Todolist

    @valid_attrs %{event_date: "2010-04-17T14:00:00Z", title: "some title"}
    @update_attrs %{event_date: "2011-05-18T15:01:01Z", title: "some updated title"}
    @invalid_attrs %{event_date: nil, title: nil}

    def todolist_fixture(attrs \\ %{}) do
      {:ok, todolist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContent.create_todolist()

      todolist
    end

    test "list_todolists/0 returns all todolists" do
      todolist = todolist_fixture()
      assert UserContent.list_todolists() == [todolist]
    end

    test "get_todolist!/1 returns the todolist with given id" do
      todolist = todolist_fixture()
      assert UserContent.get_todolist!(todolist.id) == todolist
    end

    test "create_todolist/1 with valid data creates a todolist" do
      assert {:ok, %Todolist{} = todolist} = UserContent.create_todolist(@valid_attrs)
      assert todolist.event_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert todolist.title == "some title"
    end

    test "create_todolist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContent.create_todolist(@invalid_attrs)
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
      assert todolist == UserContent.get_todolist!(todolist.id)
    end

    test "delete_todolist/1 deletes the todolist" do
      todolist = todolist_fixture()
      assert {:ok, %Todolist{}} = UserContent.delete_todolist(todolist)
      assert_raise Ecto.NoResultsError, fn -> UserContent.get_todolist!(todolist.id) end
    end

    test "change_todolist/1 returns a todolist changeset" do
      todolist = todolist_fixture()
      assert %Ecto.Changeset{} = UserContent.change_todolist(todolist)
    end
  end
end
