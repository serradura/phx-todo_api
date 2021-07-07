defmodule TodoApi.CurrentUser do
  @moduledoc """
  The CurrentUser context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.{User, Session}

  def find_by_session(%Session{user_id: user_id}) do
    case Repo.get(User, user_id) do
      nil  -> :error
      user -> {:ok, user}
    end
  end

  def get_todo!(%User{id: user_id}, id) do
    Repo.get_by!(Todo, [id: id, owner_id: user_id])
  end

  def create_todo(%User{id: user_id}, todo_params) do
    todo_params
    |> Map.put("owner_id", user_id)
    |> Todos.create_todo()
  end

  def list_todos(%User{id: user_id}) do
    from(t in Todo, where: t.owner_id == ^user_id)
    |> Repo.all()
  end
end
