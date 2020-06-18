defmodule TodoWeb.TodolistControllerTest do
  use TodoWeb.ConnCase

  alias Todo.UserContent
  alias Todo.UserContent.Todolist

  @create_attrs %{
    event_date: "2010-04-17T14:00:00Z",
    title: "some title"
  }
  @update_attrs %{
    event_date: "2011-05-18T15:01:01Z",
    title: "some updated title"
  }
  @invalid_attrs %{event_date: nil, title: nil}

  def fixture(:todolist) do
    {:ok, todolist} = UserContent.create_todolist(@create_attrs)
    todolist
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todolists", %{conn: conn} do
      conn = get(conn, Routes.todolist_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todolist" do
    test "renders todolist when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todolist_path(conn, :create), todolist: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todolist_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_date" => "2010-04-17T14:00:00Z",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todolist_path(conn, :create), todolist: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todolist" do
    setup [:create_todolist]

    test "renders todolist when data is valid", %{conn: conn, todolist: %Todolist{id: id} = todolist} do
      conn = put(conn, Routes.todolist_path(conn, :update, todolist), todolist: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todolist_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_date" => "2011-05-18T15:01:01Z",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todolist: todolist} do
      conn = put(conn, Routes.todolist_path(conn, :update, todolist), todolist: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todolist" do
    setup [:create_todolist]

    test "deletes chosen todolist", %{conn: conn, todolist: todolist} do
      conn = delete(conn, Routes.todolist_path(conn, :delete, todolist))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todolist_path(conn, :show, todolist))
      end
    end
  end

  defp create_todolist(_) do
    todolist = fixture(:todolist)
    {:ok, todolist: todolist}
  end
end
