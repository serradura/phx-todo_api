defmodule TodoApi.AuthenticationTest do
  use TodoApiWeb.ConnCase

  alias TodoApi.{Repo, Authentication}
  alias TodoApi.Accounts.{User, Session}

  @opts Authentication.init([])

  describe "accounts authentication" do
    def put_auth_token_in_header(conn, token) do
      conn
      |> put_req_header("authorization", "Token token=\"#{token}\"")
    end

    test "assigns the user when receiving a valid token", %{conn: conn} do
      user = Repo.insert!(%User{})
      session = Repo.insert!(%Session{token: "123", user_id: user.id})

      conn = conn
      |> put_auth_token_in_header(session.token)
      |> Authentication.call(@opts)

      assert conn.assigns.current_user
    end

    test "forbids when receiving an invalid token", %{conn: conn} do
      conn = conn
      |> put_auth_token_in_header("foo")
      |> Authentication.call(@opts)

      assert conn.status == 401
      assert conn.halted
    end

    test "forbids when the connection hasn't a token", %{conn: conn} do
      conn = Authentication.call(conn, @opts)
      assert conn.status == 401
      assert conn.halted
    end
  end
end
