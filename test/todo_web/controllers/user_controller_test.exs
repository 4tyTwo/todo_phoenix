defmodule TodoWeb.UserControllerTest do
  use TodoWeb.ConnCase

  @username "4tyTwo"
  @password "qwerty123"

  test "Sign up", %{conn: conn} do
    assert %{"jwt" => _} = sign_up(conn)
  end

  test "Sing in", %{conn: conn} do
    %{"jwt" => jwt0} = sign_up(conn)
    %{"jwt" => jwt1} = post(conn, Routes.user_path(conn, :sign_in), %{
      "username" => @username,
      "password" => @password
    })
    |> json_response(200)
    assert jwt0 == jwt1
  end

  defp sign_up(conn) do
    post(conn, Routes.user_path(conn, :create), %{"user" => %{
      "username" => @username,
      "password" => @password
    }})
    |> json_response(201)
  end

end
