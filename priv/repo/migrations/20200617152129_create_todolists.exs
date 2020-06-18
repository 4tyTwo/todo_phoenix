defmodule Todo.Repo.Migrations.CreateTodolists do
  use Ecto.Migration

  def change do
    create table(:todolists) do
      add :event_date, :utc_datetime, null: false
      add :title, :string, null: false
      add :description, :string
      add :user_id, references( :users, on_delete: :nothing)

      timestamps()
    end

  end
end
