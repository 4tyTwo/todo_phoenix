defmodule Todo.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :token, :string
    belongs_to :user, Todo.Accounts.User
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
