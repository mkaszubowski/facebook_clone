defmodule FacebookClone.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text
      add :user_id, :integer, null: false

      timestamps
    end

    create index(:posts, [:user_id])
  end
end
