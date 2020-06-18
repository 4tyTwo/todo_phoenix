defmodule Todo.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.Accounts.User
  alias Todo.Accounts.Token
  alias Todo.Guardian
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_token(user_id), do: Repo.get_by(Token, user_id: user_id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    {:ok, user} = res = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    create_token(user)
    res
  end

  def create_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    %Token{}
    |> Token.changeset(%{token: token})
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def token_sign_in(username, password) do
    case username_password_auth(username, password) do
      {:ok, user} ->
        case get_token(user.id) do
          nil -> {:error, :unauthorized}
          token -> maybe_reissue_token(user, token)
        end
      _ ->
        {:error, :unauthorized}
    end
  end

  defp maybe_reissue_token(%User{} = user, %Token{token: token} = t) do
    case Guardian.decode_and_verify(token) do
      {:error, _} -> create_token(user) # TODO: match only on expiration error
      {:ok, _} -> {:ok, t}
    end
  end

  defp username_password_auth(username, password) do
    with {:ok, user} <- get_by_username(username),
    do: verify_password(password, user)
  end

  defp get_by_username(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        dummy_checkpw()
        {:error, "Login error"}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
