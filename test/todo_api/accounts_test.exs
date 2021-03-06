defmodule TodoApi.AccountsTest do
  use TodoApi.DataCase

  alias TodoApi.Repo
  alias TodoApi.Accounts

  describe "users" do
    alias TodoApi.Accounts.User

    @valid_attrs %{email: "some-email@test.com", password: "s3cr3t"}
    @update_attrs %{email: "some-updated-email@test.com", password: "s3CR3t"}
    @invalid_attrs %{email: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = %User{user_fixture() | password: nil}
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = %User{user_fixture() | password: nil}
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = %User{user_fixture(@valid_attrs) | password: nil}
      assert Accounts.get_user_by_email(@valid_attrs.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some-email@test.com"
      assert Argon2.verify_pass("s3cr3t", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some-updated-email@test.com"
      assert Argon2.verify_pass("s3CR3t", user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert %User{user | password: nil} == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/2 with valid attributes" do
      changeset = Accounts.change_user(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "change_user/2 with invalid attributes" do
      changeset = Accounts.change_user(%User{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "change_user/2 with an invalid email" do
      changeset = Accounts.change_user(%User{}, %{@valid_attrs | email: "foo"})
      refute changeset.valid?
    end

    test "change_user/2 with an invalid password length" do
      changeset = Accounts.change_user(%User{}, %{@valid_attrs | password: "12345"})
      refute changeset.valid?
    end
  end

  describe "sessions" do
    alias TodoApi.Accounts.User
    alias TodoApi.Accounts.Session

    test "create_user/1 with valid data creates a session" do
      {:ok, user} =
        %{email: "some-email@test.com", password: "s3cr3t"}
        |> Accounts.create_user()

      assert {:ok, %Session{} = session} = Accounts.create_session(user)

      assert session.user_id == user.id
      assert session == Repo.get_by(Session, token: session.token)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(%User{})
    end

    test "change_session/2 returns a session changeset" do
      assert %Ecto.Changeset{} = Accounts.change_session(%Session{}, %{})
    end

    test "change_session/2 with valid attributes" do
      changeset = Accounts.change_session(%Session{}, %{user_id: "12345"})
      assert changeset.valid?
      assert changeset.changes.token
    end

    test "change_session/2 with invalid attributes" do
      changeset = Accounts.change_session(%Session{}, %{user_id: ""})
      refute changeset.valid?
      assert changeset.changes == %{}
    end
  end
end
