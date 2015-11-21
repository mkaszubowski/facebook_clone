defmodule FacebookClone.Repo.Migrations.FixFriendshipsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:friendships, [:user_id, :friend_id])
  end
end
