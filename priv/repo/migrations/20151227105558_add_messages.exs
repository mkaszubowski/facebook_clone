defmodule FacebookClone.Repo.Migrations.AddMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :conversation_id, references(:conversations), null: false
      add :user_id, references(:users), null: false
      add :content, :string

      timestamps
    end
  end
end
