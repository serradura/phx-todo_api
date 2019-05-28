defmodule TodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :complete, :boolean, default: false
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :complete])
    |> validate_required([:description, :complete])
  end
end
