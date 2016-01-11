defmodule FacebookClone.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :file, :string
      add :user_id, references(:users), null: false
      add :description, :string

      timestamps
    end
  end
end
