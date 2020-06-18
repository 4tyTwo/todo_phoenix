defmodule Todo.Repo.Migrations.AddJwtToUsers do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :user_id, references( :users, on_delete: :nothing)
      add :token, :text
    end
  end
end
