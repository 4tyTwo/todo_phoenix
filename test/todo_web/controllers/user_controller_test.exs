defmodule TodoWeb.UserControllerTest do
  use TodoWeb.ConnCase

  @username "4tyTwo"
  @password "qwerty123"

  test "Sign up", %{conn: conn} do
    assert %{"jwt" => _} = sign_up(conn, @username, @password)
  end

  test "Sing in", %{conn: conn} do
    %{"jwt" => jwt0} = sign_up(conn, @username, @password)
    %{"jwt" => jwt1} = sign_in(conn, @username, @password)
    assert jwt0 == jwt1
  end

  test "Get myself", %{conn: conn} do
    %{"jwt" => jwt} = sign_up(conn, @username, @password)
    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> jwt) # TODO: use httpoison/Tesla for requests
    %{"username" => @username} = get(conn, Routes.user_path(conn, :show)) |> json_response(200)
  end

  defp sign_in(conn, username, password) do
    post(conn, Routes.user_path(conn, :sign_in), %{
      "username" => username,
      "password" => password
    })
    |> json_response(200)
  end

  defp sign_up(conn, username, password) do
    post(conn, Routes.user_path(conn, :create), %{"user" => %{
      "username" => username,
      "password" => password
    }})
    |> json_response(201)
  end

end
