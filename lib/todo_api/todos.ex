defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.User

  defp get_owner_id(options) when is_list(options) do
    case options do
      [{:owner, %User{id: id}} | _] -> id
      [{:owner_id, owner_id}   | _] -> owner_id
      _ -> nil
    end
  end

  defp query_todos_by_owner_id(options)
  when is_list(options),
  do:  get_owner_id(options) |> query_todos_by_owner_id()

  defp query_todos_by_owner_id(nil),
  do:  from(t in Todo)

  defp query_todos_by_owner_id(owner_id),
  do:  from(t in Todo, where: t.owner_id == ^owner_id)

  defp query_todo(id, options),
  do:  query_todos_by_owner_id(options) |> where(id: ^id)

  def list_todos(options \\ []) do
    query_todos_by_owner_id(options)
    |> Repo.all()
  end

  def get_todo!(id, options \\ []) do
    query_todo(id, options)
    |> Repo.one!()
  end

  def create_todo(attrs \\ %{}, options \\ []) do
    %Todo{owner_id: get_owner_id(options)}
    |> change_todo(attrs)
    |> Repo.insert()
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> change_todo(attrs)
    |> Repo.update()
  end

  def delete_todo(_, options \\ [])

  def delete_todo(%Todo{} = todo, options) do
    if(:ok = delete_todo(todo.id, options), do: {:ok, todo}) || :error
  end

  def delete_todo(id, options) do
    {1, nil} = query_todo(id, options) |> Repo.delete_all()
    :ok
  end

  def change_todo(%Todo{} = todo, attrs \\ %{})
  when is_map(attrs),
  do:  Todo.changeset(todo, attrs)
end
