defmodule FacebookClone.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      timestamps
    end
  end
end
