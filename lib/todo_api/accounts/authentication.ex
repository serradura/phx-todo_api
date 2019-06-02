defmodule TodoApi.Accounts.Authentication do
  import Ecto.Query, only: [from: 2]

  alias TodoApi.Repo
  alias TodoApi.Accounts.{User, Session}

  def find_user_by_token(token) do
    case get_user_by_token(token) do
      nil  -> :error
      user -> {:ok, user}
    end
  end

  def get_user_by_token(token) do
    token
    |> query_user_by_session()
    |> Repo.one()
  end

  defp query_user_by_session(token) do
    from u in User,
    join: s in Session,
    where: u.id == s.user_id and s.token == ^token
  end
end
