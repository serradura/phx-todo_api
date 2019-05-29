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

  def list_sessions do
    Repo.all(Session)
  end

  def get_session!(id), do: Repo.get!(Session, id)

  def create_session(attrs \\ %{}) do
    %Session{}
    |> change_session(attrs)
    |> Repo.insert()
  end

  def update_session(%Session{} = session, attrs) do
    session
    |> change_session(attrs)
    |> Repo.update()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  def change_session(%Session{} = session, attrs \\ %{})
    when is_map(attrs),
    do: Session.changeset(session, attrs)
end
