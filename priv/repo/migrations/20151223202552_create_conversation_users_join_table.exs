defmodule FacebookClone.Repo.Migrations.CreateConversationUsersJoinTable do
  use Ecto.Migration

  def change do
    create table(:conversation_users) do
      add :user_id, references(:users), null: false
      add :conversation_id, references(:conversations), null: false

      timestamps
    end

    create unique_index(:conversation_users, [:user_id, :conversation_id])
  end
end
