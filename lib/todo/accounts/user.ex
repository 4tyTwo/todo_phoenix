defmodule Todo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :username, :string

    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 6, max: 30)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
