defmodule FacebookClone.Repo.Migrations.CreateGroupUsers do
  use Ecto.Migration

  def change do
    create table(:group_users) do
      add :user_id, references(:users), null: false
      add :group_id, references(:groups), null: false

      timestamps
    end

    create unique_index(:group_users, [:user_id, :group_id])
  end
end
