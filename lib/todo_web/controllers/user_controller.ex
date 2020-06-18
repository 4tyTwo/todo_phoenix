defmodule TodoWeb.UserController do
  use TodoWeb, :controller

  alias Todo.Accounts
  alias Todo.Accounts.User
  alias Todo.Accounts.Token
  alias Todo.Guardian

  action_fallback TodoWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    {:ok, %User{} = user} = Accounts.create_user(user_params)
    %Token{token: token} = Accounts.get_token(user.id)
    conn
    |> put_status(:created)
    |> render("jwt.json", jwt: token)
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Accounts.token_sign_in(username, password) do
      {:ok, %Token{token: token}} ->
        render(conn, "jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, _params) do
     user = Guardian.Plug.current_resource(conn)
     conn |> render("user.json", user: user)
  end
end
