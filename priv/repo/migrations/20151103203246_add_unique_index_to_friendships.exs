defmodule FacebookClone.Repo.Migrations.AddUniqueIndexToFriendships do
  use Ecto.Migration

  def change do
    create unique_index(:friendships, [:user_one_id, :user_two_id])
  end
end
