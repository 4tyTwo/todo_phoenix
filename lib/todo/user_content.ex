defmodule Todo.UserContent do
  @moduledoc """
  The UserContent context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.UserContent.Todolist
  alias Todo.Accounts.User

  def list_todolists(%User{id: id}) do
    from(t in Todolist, select: t, where: t.user_id == ^id) |> Repo.all()
  end

  def get_todolist(%User{id: user_id}, id) do
    case Repo.get(Todolist, id) do
      %Todolist{user_id: ^user_id} = list -> {:ok, list}
      _ -> {:error, :not_found}
    end
  end

  def create_todolist(user, attrs \\ %{}) do
    %Todolist{}
    |> Todolist.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end


  def update_todolist(%Todolist{} = todolist, attrs) do
    todolist
    |> Todolist.changeset(attrs)
    |> Repo.update()
  end

  def delete_todolist(%User{id: user_id}, %Todolist{user_id: user_id} = todolist) do
    Repo.delete(todolist)
  end

  def delete_todolist(_, _) do
    {:error, :not_found}
  end

  def change_todolist(%Todolist{} = todolist) do
    Todolist.changeset(todolist, %{})
  end
end
