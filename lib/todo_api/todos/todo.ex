defmodule TodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoApi.Accounts.User

  schema "todos" do
    field :complete, :boolean, default: false
    field :description, :string
    belongs_to :user, User, references: :users, foreign_key: :owner_id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :complete, :owner_id])
    |> validate_required([:description, :complete, :owner_id])
  end
end
