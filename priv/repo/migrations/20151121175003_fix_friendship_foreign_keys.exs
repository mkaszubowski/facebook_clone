defmodule FacebookClone.Repo.Migrations.FixFriendshipForeignKeys do
  use Ecto.Migration

  def change do
    execute """
      ALTER TABLE friendships DROP CONSTRAINT friends_user_id_fkey
    """
    execute """
      ALTER TABLE friendships DROP CONSTRAINT friends_friend_id_fkey
    """

    drop table(:friendships)

    create table(:friendships) do
      add :user_id, references(:users), null: false
      add :friend_id, references(:users), null: false

      timestamps
    end
  end
end
