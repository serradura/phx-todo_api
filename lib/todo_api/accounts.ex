defmodule TodoApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> change_user(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> change_user(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{})
    when is_map(attrs),
    do: User.changeset(user, attrs)

  alias TodoApi.Accounts.Session

  def create_session(%User{id: user_id}) do
    %Session{}
    |> change_session(%{"user_id" => user_id})
    |> Repo.insert()
  end

  def change_session(%Session{} = session, attrs \\ %{})
    when is_map(attrs),
    do: Session.changeset(session, attrs)
end
