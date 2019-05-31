defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo

  plug TodoApi.Authentication

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    todos = Todos.list_todos(user)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    user = conn.assigns.current_user
    todo_params = Map.put(todo_params, "owner_id", user.id)

    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    todo = Todos.get_todo!(id, user)

    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    user = conn.assigns.current_user
    todo = Todos.get_todo!(id, user)

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    todo = Todos.get_todo!(id, user)

    with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
