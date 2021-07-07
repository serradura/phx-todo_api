defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo
  alias TodoApi.Todos.Todo

  def list_todos, do: Repo.all(Todo)

  def get_todo!(id), do: Repo.get!(Todo, id)
end
