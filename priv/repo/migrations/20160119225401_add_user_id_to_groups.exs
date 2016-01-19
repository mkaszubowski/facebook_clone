defmodule FacebookClone.Repo.Migrations.AddUserIdToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :user_id, references(:users)
    end

    create index(:groups, [:user_id])
  end
end
