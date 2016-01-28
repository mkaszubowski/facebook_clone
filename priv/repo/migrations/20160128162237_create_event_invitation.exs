defmodule FacebookClone.Repo.Migrations.CreateEventInvitation do
  use Ecto.Migration

  def change do
    create table(:event_invitations) do
      add :event_id, references(:events), null: false
      add :user_id, references(:users), null: false
      add :invited_by_id, references(:users), null: false

      timestamps
    end

    create unique_index(:event_invitations, [:event_id, :user_id, :invited_by_id])

  end
end
