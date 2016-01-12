defmodule FacebookClone.PhotoView do
  use FacebookClone.Web, :view

  alias FacebookClone.PhotoFile

  import FacebookClone.UserView, only: [full_name: 1]

  def new_photo_link(conn, user) do
    link "Add new", to: user_photo_path(conn, :new, user), class: "new-photo-link"
  end

  def photo_path(photo) do
    url = PhotoFile.url({photo.photo_file, photo}, :original)
    String.replace(url, "priv/static", "")
  end
end
