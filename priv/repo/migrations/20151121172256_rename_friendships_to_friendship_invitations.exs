defmodule FacebookClone.Repo.Migrations.RenameFriendshipsToFriendshipInvitations do
  use Ecto.Migration

  def change do
    drop table(:friendships)

    create table(:friendship_invitations) do
      add :user_id, references(:users), null: false
      add :invited_id, references(:users), null: false
    end

    create table(:friends) do
      add :user_id, references(:users), null: false
      add :friend_id, references(:users), null: false
    end

    create unique_index(:friendship_invitations,
      [:user_id, :invited_id])
    create unique_index(:friends, [:user_id, :friend_id])
  end
end
