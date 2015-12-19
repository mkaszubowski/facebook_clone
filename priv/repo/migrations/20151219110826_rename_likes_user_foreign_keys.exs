defmodule FacebookClone.Repo.Migrations.RenameLikesUserForeignKeys do
  use Ecto.Migration

  def change do
    execute """
      ALTER TABLE likes DROP CONSTRAINT like_user_id_fkey
    """
    execute """
      ALTER TABLE likes ADD CONSTRAINT likes_user_id_fkey FOREIGN KEY(user_id) REFERENCES users(id)
    """
  end
end
