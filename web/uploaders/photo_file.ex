defmodule FacebookClone.PhotoFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def __storage, do: Arc.Storage.Local

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png"}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  def storage_dir(version, {file, scope}) do
    "priv/static/images/photos"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end
end
