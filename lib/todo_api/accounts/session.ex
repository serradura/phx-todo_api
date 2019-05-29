defmodule TodoApi.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
