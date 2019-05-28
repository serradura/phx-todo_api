defmodule TodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :description, :string
      add :complete, :boolean, default: false, null: false

      timestamps()
    end

  end
end
