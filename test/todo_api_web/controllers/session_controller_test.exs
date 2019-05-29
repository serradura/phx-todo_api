defmodule TodoApiWeb.SessionControllerTest do
  use TodoApiWeb.ConnCase

  alias TodoApi.Repo
  alias TodoApi.Accounts
  alias TodoApi.Accounts.Session

  @create_attrs %{
    email: "foo@bar.com",
    password: "s3cr3t"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create session" do
    test "renders session when data is valid", %{conn: conn} do
      Accounts.create_user(@create_attrs)

      conn = post(conn, Routes.session_path(conn, :create), user: @create_attrs)

      %{"data" => %{"token" => token}} = json_response(conn, 201)

      assert %Session{token: token} = Repo.get_by(Session, token: token)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), user: %{"email" => ""})
      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
