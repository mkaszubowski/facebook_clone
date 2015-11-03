defmodule FacebookClone.Repo.Migrations.CreateFriendship do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user_one_id, references(:users), null: false
      add :user_two_id, references(:users), null: false
      add :accepted, :boolean, default: false

      timestamps
    end
  end
end
