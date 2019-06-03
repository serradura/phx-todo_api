defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos

  plug TodoApiWeb.Plug.Authentication

  action_fallback TodoApiWeb.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn,
                                          conn.params,
                                          conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    todos = Todos.list_todos(owner: current_user)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, current_user) do
    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params, owner: current_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    todo = Todos.get_todo!(id, owner: current_user)

    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, current_user) do
    todo = Todos.get_todo!(id, owner: current_user)

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with :ok <- Todos.delete_todo(id, owner: current_user) do
      send_resp(conn, :no_content, "")
    end
  end
end
