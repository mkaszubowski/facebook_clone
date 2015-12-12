defmodule FacebookClone.Repo.Migrations.CreateLike do
  use Ecto.Migration

  def change do
    create table(:like) do
      add :post_id, references(:posts), null: false
      add :user_id, references(:users), null: false

      timestamps
    end
  end
end
