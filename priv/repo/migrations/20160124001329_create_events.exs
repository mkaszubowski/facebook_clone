defmodule FacebookClone.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :description, :string
      add :user_id, references(:users), null: false
      add :date, :datetime, null: false

      timestamps
    end
  end
end
