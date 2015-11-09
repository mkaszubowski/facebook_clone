defmodule FacebookClone.Repo.Migrations.AddIndicesToUsers do
  use Ecto.Migration

  def change do
    create index(:users, [:first_name])
    create index(:users, [:last_name])
  end
end
