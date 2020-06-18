defmodule TodoWeb.TodolistController do
  use TodoWeb, :controller

  alias Todo.UserContent
  alias Todo.UserContent.Todolist

  action_fallback TodoWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    todolists = UserContent.list_todolists(user)
    render(conn, "index.json", todolists: todolists)
  end

  def create(conn, %{"todolist" => todolist_params}) do
    user = conn.assigns.current_user
    with {:ok, %Todolist{} = todolist} <- UserContent.create_todolist(user, todolist_params) do
      conn
      |> put_status(:created)
      |> render("show.json", todolist: todolist)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    with {:ok, todolist} = UserContent.get_todolist(user, id) do
      render(conn, "show.json", todolist: todolist)
    end
  end

  def update(conn, %{"id" => id, "todolist" => todolist_params}) do
    user = conn.assigns.current_user
    case UserContent.get_todolist(user, id) do
      {:error, :not_found} -> send_resp(conn, 404, "Not found")
      {:ok, todolist} -> do_update(conn, todolist, todolist_params)
    end
  end

  defp do_update(conn, todolist, todolist_params) do
    case UserContent.update_todolist(todolist, todolist_params) do
      {:ok, %Todolist{} = todolist} -> render(conn, "show.json", todolist: todolist)
      {:error, _} -> send_resp(conn, 400, "Invalid changes")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    with {:ok, todolist} = UserContent.get_todolist(user, id),
      {:ok, %Todolist{}} <- UserContent.delete_todolist(user, todolist) do
      send_resp(conn, :no_content, "")
    end
  end
end
