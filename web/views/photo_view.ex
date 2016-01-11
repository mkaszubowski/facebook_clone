defmodule FacebookClone.PhotoView do
  use FacebookClone.Web, :view

  alias FacebookClone.PhotoFile

  def photo_path(photo) do
    url = PhotoFile.url({photo.photo_file, photo}, :original)
    String.replace(url, "priv/static", "")
  end
end
