defmodule FacebookClone.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  def change do
    create table(:event_users) do
      add :user_id, references(:users), null: false
      add :event_id, references(:events), null: false

      timestamps
    end

    create unique_index(:event_users, [:event_id, :user_id])
  end
end
