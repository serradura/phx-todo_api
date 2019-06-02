defmodule TodoApi.TodosTest do
  use TodoApi.DataCase

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Accounts

  describe "todos" do
    alias TodoApi.Todos.Todo

    @valid_attrs %{complete: true, description: "some description"}

    def current_user do
      {:ok, user} = Accounts.create_user(%{
                      email: "johndoe@example.com", password: "123456"
                    })
      user
    end

    def todo_fixture do
      {:ok, todo} =
        @valid_attrs
        |> Map.put(:owner_id, current_user().id)
        |> (&Todo.changeset(%Todo{}, &1)).()
        |> Repo.insert()
      todo
    end

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "get_todo!/1 raises an error when the given id isn't found" do
      assert_raise Ecto.NoResultsError, fn ->
        Todos.get_todo!(9_999)
      end
    end
  end
end
