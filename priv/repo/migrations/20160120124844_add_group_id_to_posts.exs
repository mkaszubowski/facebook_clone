defmodule FacebookClone.Repo.Migrations.AddGroupIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :group_id, :integer
    end

    create index(:posts, [:group_id])
  end
end
