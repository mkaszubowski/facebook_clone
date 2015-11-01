defmodule FacebookClone.Repo.Migrations.AddProfileInfoToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :city, :string
      add :birthday, :date
      add :gender, :integer
    end
  end
end
