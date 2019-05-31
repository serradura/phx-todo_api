defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.User

  def list_todos, do: Repo.all(Todo)

  def get_todo!(id), do: Repo.get!(Todo, id)

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
