defmodule TodoApiWeb.TodoControllerTest do
  use TodoApiWeb.ConnCase

  alias TodoApi.Todos
  alias TodoApi.Accounts
  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts.User

  @create_attrs %{
    complete: true,
    description: "some description"
  }
  @update_attrs %{
    complete: false,
    description: "some updated description"
  }
  @invalid_attrs %{complete: nil, description: nil}

  def todo_fixture(%User{} = user), do: todo_fixture(user, @create_attrs)
  def todo_fixture(%User{} = user, attrs) when is_map(attrs) do
    {:ok, todo} = Todos.WithOwner.create_todo(user, attrs)
    todo
  end

  def create_user(%{name: name}) do
    %{email: "#{name}@example.com", password: "123456"}
    |> Accounts.create_user()
  end

  setup %{conn: conn} do
    {:ok, user} = create_user(%{name: "jane"})
    {:ok, session} = Accounts.create_session(user)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    {:ok, conn: conn, current_user: user }
  end

  describe "index" do
    test "lists all todos", %{conn: conn, current_user: current_user} do
      todo_fixture(current_user, %{description: "our first todo"})

      {:ok, another_user} = create_user(%{name: "johndoe"})
      todo_fixture(another_user, %{description: "thier first todo"})

      conn = get(conn, Routes.todo_path(conn, :index))
      body = json_response(conn, 200)
      data = body["data"]

      assert Enum.count(data) == 1
      assert %{"description" => "our first todo"} = hd(data)
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "complete" => true,
               "description" => "some description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    test "renders todo when data is valid", %{conn: conn, current_user: user} do
      %Todo{id: id} = todo = todo_fixture(user)

      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => id,
               "complete" => false,
               "description" => "some updated description"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, current_user: user} do
      todo = todo_fixture(user)
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    test "deletes chosen todo", %{conn: conn, current_user: user} do
      todo = todo_fixture(user)
      conn = delete(conn, Routes.todo_path(conn, :delete, todo))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.todo_path(conn, :show, todo))
      end
    end
  end
end
