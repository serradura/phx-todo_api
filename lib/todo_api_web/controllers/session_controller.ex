defmodule TodoApiWeb.SessionController do
  use TodoApiWeb, :controller

  alias TodoApi.Accounts
  alias TodoApi.Accounts.User

  action_fallback TodoApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with %User{} = user <- get_user(user_params),
         {:ok, session} <- Accounts.create_session(user) do
      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    else
      _ ->
        {:error, :unauthorized}
    end
  end

  defp valid_user_password?(%User{} = user, password) do
    Argon2.verify_pass(password, user.password_hash)
  end

  defp get_user(%{"email" => email, "password" => password}) do
    with user <- Accounts.get_user_by_email(email),
         true <- valid_user_password?(user, password),
    do:  user
  end

  defp get_user(_), do: nil
end
