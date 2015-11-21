defmodule FacebookClone.Repo.Migrations.RenameFriendsToFriendships do
  use Ecto.Migration

  def change do
    rename table(:friends), to: table(:friendships)
  end
end
