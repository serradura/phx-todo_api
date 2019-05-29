defmodule TodoApi.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoApi.Accounts

  schema "sessions" do
    field :token, :string
    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> put_token()
  end

  defp put_token(%Ecto.Changeset{valid?: true} = chset),
    do: put_change(chset, :token, SecureRandom.urlsafe_base64())

  defp put_token(chset), do: chset
end
