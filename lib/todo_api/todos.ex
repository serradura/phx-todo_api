defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.User

  def list_todos, do: Repo.all(Todo)
  def list_todos(%User{id: id}) do
    from(t in Todo, where: t.owner_id == ^id)
    |> Repo.all()
  end

  def get_todo!(id), do: Repo.get!(Todo, id)
  def get_todo!(id, %User{id: user_id}) do
    Repo.get_by!(Todo, [id: id, owner_id: user_id])
  end

  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> change_todo(attrs)
    |> Repo.insert()
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> change_todo(attrs)
    |> Repo.update()
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  def change_todo(%Todo{} = todo, attrs \\ %{})
    when is_map(attrs),
    do: Todo.changeset(todo, attrs)
end
