defmodule FacebookClone.Repo.Migrations.ChangeUniqueIndexForEventInvitations do
  use Ecto.Migration

  def change do
    drop unique_index(:event_invitations, [:event_id, :user_id, :invited_by_id])
    create unique_index(:event_invitations, [:event_id, :user_id])
  end
end
