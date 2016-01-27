defmodule FacebookClone.PhotoView do
  use FacebookClone.Web, :view

  alias FacebookClone.PhotoFile

  import FacebookClone.UserView, only: [full_name: 1]

  def new_photo_link(conn, user) do
    link "Add new", to: user_photo_path(conn, :new, user), class: "new-photo-link"
  end

  def delete_link(conn, photo, current_user) do
    if photo.user_id == current_user.id, do:
      link "Delete",
        to: user_photo_path(conn, :delete, current_user, photo),
        method: :delete
  end

  def edit_link(conn, photo, current_user) do
    if photo.user_id == current_user.id, do:
      link "Edit", to: user_photo_path(conn, :edit, current_user, photo)
  end

  def photo_path(photo) do
    url = PhotoFile.url({photo.photo_file, photo}, :original)

    if is_nil(url), do: "", else: String.replace(url, "priv/static", "")
  end

  def render_form(conn, current_user) do
    render "_form.html",
      conn: conn,
      path: user_photo_path(conn, :create, current_user),
      method: :post
  end

  def render_form(conn, current_user, photo) do
    render "_form.html",
      conn: conn,
      path: user_photo_path(conn, :update, current_user, photo),
      method: :put
  end
end
