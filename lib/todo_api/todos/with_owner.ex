defmodule TodoApi.Todos.WithOwner do
  @moduledoc """
  The Todos.Owner context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.User

  def list_todos(%User{id: id}) do
    from(t in Todo, where: t.owner_id == ^id)
    |> Repo.all()
  end

  def get_todo!(%User{id: user_id}, id) do
    Repo.get_by!(Todo, [id: id, owner_id: user_id])
  end

  def create_todo(%User{} = user, attrs) do
    user
    |> change_todo(%Todo{}, attrs)
    |> Repo.insert()
  end

  def update_todo(%User{} = user, todo, attrs) do
    user
    |> change_todo(todo, attrs)
    |> Repo.update()
  end

  def delete_todo(%User{id: user_id}, todo_id) do
    query = from t in Todo, where: t.owner_id == ^user_id and t.id == ^todo_id

    {1, nil} = Repo.delete_all(query)

    :ok
  end

  def change_todo(%User{id: user_id}, %Todo{owner_id: owner_id} = todo, attrs)
  when is_map(attrs) do
    cond do
      is_integer(user_id) and is_nil(owner_id) ->
        Todo.changeset(%Todo{todo | owner_id: user_id}, attrs)
      is_integer(user_id) and is_integer(owner_id) and user_id == owner_id ->
        Todo.changeset(todo, attrs)
      :else -> :error
    end
  end
end
