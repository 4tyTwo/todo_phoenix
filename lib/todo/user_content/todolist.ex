defmodule Todo.UserContent.Todolist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todolists" do
    field :event_date, :utc_datetime
    field :title, :string
    field :description, :string
    belongs_to :user, Todo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(todolist, attrs) do
    todolist
    |> cast(attrs, [:event_date, :title, :description])
    |> validate_required([:event_date, :title])
  end
end
