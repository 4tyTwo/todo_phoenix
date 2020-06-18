defmodule TodoWeb.Plug.CurrentUser do
  alias Todo.Guardian
  alias Todo.Accounts
  def init(_) do
    nil
  end

  def call(conn, _) do
    maybe_insert_user(conn)
  end

  defp maybe_insert_user(conn) do
    case extract_claims(conn) do
      {:ok, %{"sub" => user_id}} -> maybe_get_user(conn, user_id)
      _ -> conn
    end
  end

  defp maybe_get_user(conn, id) do
    case Accounts.get_user(id) do
      nil  -> conn
      user -> Plug.Conn.assign(conn, :current_user, user)
    end
  end

  defp extract_claims(conn) do
    conn.req_headers
    |> Enum.into(%{})
    |> Map.fetch!("authorization")
    |> String.split()
    |> Enum.at(1)
    |> Guardian.decode_and_verify()
  end
end
