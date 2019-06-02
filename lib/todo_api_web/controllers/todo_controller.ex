defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos

  plug TodoApi.Authentication

  action_fallback TodoApiWeb.FallbackController

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn,
                                          conn.params,
                                          conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    todos = Todos.WithOwner.list_todos(current_user)
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}, current_user) do
    with {:ok, todo} <- Todos.WithOwner.create_todo(current_user, todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    todo = Todos.WithOwner.get_todo!(current_user, id)

    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}, current_user) do
    todo = Todos.WithOwner.get_todo!(current_user, id)

    with {:ok, todo} <- Todos.WithOwner.update_todo(current_user, todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with :ok <- Todos.WithOwner.delete_todo(current_user, id) do
      send_resp(conn, :no_content, "")
    end
  end
end
