defmodule TodoApi.Authentication do
  import Plug.Conn

  alias TodoApi.Accounts.Authentication

  def init(options), do: options

  def call(conn, _opts) do
    case find_user(conn) do
      {:ok, user} -> assign(conn, :current_user, user)
      _otherwise  -> auth_error!(conn)
    end
  end

  defp find_user(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token} <- parse_token(auth_header),
    do:  Authentication.find_user_by_token(token)
  end

  defp parse_token(["Token token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end
  defp parse_token(_non_token_header), do: :error

  defp auth_error!(conn) do
    put_status(conn, :unauthorized)
    |> halt()
  end
end
