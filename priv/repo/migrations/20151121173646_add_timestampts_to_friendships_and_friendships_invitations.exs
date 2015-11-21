defmodule FacebookClone.Repo.Migrations.AddTimestamptsToFriendshipsAndFriendshipsInvitations do
  use Ecto.Migration

  def change do
    alter table(:friendships) do
      timestamps
    end

    alter table(:friendship_invitations) do
      timestamps
    end
  end
end
