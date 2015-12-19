defmodule FacebookClone.Repo.Migrations.RenameLikesForeignKeys do
  use Ecto.Migration

  def change do
    execute """
      ALTER TABLE likes DROP CONSTRAINT like_post_id_fkey
    """
    execute """
      ALTER TABLE likes ADD CONSTRAINT likes_post_id_fkey FOREIGN KEY(post_id) REFERENCES posts(id)
    """
  end
end
