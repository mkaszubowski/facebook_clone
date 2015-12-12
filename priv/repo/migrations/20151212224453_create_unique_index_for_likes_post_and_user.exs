defmodule FacebookClone.Repo.Migrations.CreateUniqueIndexForLikesPostAndUser do
  use Ecto.Migration

  def change do
    rename table(:like), to: table(:likes)
    create unique_index(:likes, [:user_id, :post_id])
  end
end
