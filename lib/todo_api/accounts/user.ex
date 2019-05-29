defmodule TodoApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> require_email(attrs)
    |> require_password(attrs)
    |> require_password_hash()
  end

  @doc false
  defp require_email(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
  end

  @doc false
  defp require_password(changeset, attrs) do
    changeset
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  @doc false
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        pass_hash = Argon2.hash_pwd_salt(pass)

        put_change(changeset, :password_hash, pass_hash)
      _ ->
        changeset
    end
  end

  @doc false
  defp require_password_hash(changeset) do
    if changeset.valid? do
      validate_required(changeset, [:password_hash])
    else
      changeset
    end
  end
end
