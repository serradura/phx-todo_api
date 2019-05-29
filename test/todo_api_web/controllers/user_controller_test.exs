defmodule TodoApiWeb.UserControllerTest do
  use TodoApiWeb.ConnCase

  alias TodoApi.Accounts
  alias TodoApi.Accounts.User

  @create_attrs %{
    email: "foo@bar.com",
    password: "s3cr3t"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      body = json_response(conn, 201)

      assert body["data"]["id"]
      assert body["data"]["email"]
      refute body["data"]["password"]

      assert %User{} = Accounts.get_user!(body["data"]["id"])
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
