defmodule FacebookClone.Repo.Migrations.RenameFileToPhotoFileInPhotos do
  use Ecto.Migration

  def change do
    rename table(:photos), :file, to: :photo_file
  end
end
