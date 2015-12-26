defmodule FacebookClone.Repo.Migrations.AddUsersIdsToConversation do
  use Ecto.Migration

  def change do
    alter table(:conversations) do
      add :user_one_id, references(:users), null: false
      add :user_two_id, references(:users), null: false
    end

    create unique_index(:conversations, [:user_one_id, :user_two_id])
  end
end
