defmodule TodoApi.TodosTest do
  use TodoApi.DataCase

  alias TodoApi.Todos
  alias TodoApi.Accounts
  alias TodoApi.Accounts.User

  describe "todos" do
    alias TodoApi.Todos.Todo

    @valid_attrs %{complete: true, description: "some description"}
    @update_attrs %{complete: false, description: "some updated description"}
    @invalid_attrs %{complete: nil, description: nil}

    def current_user do
      {:ok, user} = Accounts.create_user(%{
                      email: "johndoe@example.com", password: "123456"
                    })
      user
    end

    def todo_fixture(attrs \\ %{}), do: todo_fixture(attrs, current_user())
    def todo_fixture(attrs, %User{} = user) do
      {:ok, todo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:owner_id, user.id)
        |> Todos.create_todo()

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

    test "create_todo/1 with valid data creates a todo" do
      attrs = Map.put(@valid_attrs, :owner_id, current_user().id)

      assert {:ok, %Todo{} = todo} = Todos.create_todo(attrs)
      assert todo.complete == true
      assert todo.description == "some description"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, @update_attrs)
      assert todo.complete == false
      assert todo.description == "some updated description"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
