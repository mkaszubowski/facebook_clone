defmodule FacebookClone.PhotoController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Photo
  alias FacebookClone.User
  alias FacebookClone.SessionPlug
  alias FacebookClone.SessionHandler

  import SessionHandler, only: [current_user: 1]

  plug :authenticate_logged_in
  plug :authorize_user, "user_id" when action in [:new, :create, :edit, :update]
  plug :scrub_params, "photo" when action in [:create, :update]

  def index(conn, %{"user_id" => user_id}) do
    user = Repo.get(User, String.to_integer(user_id)) |> Repo.preload(:photos)
    photos = user.photos

    render conn, "index.html", user: user, photos: photos
  end

  def new(conn, _) do
    render conn, "new.html", current_user: current_user(conn)
  end

  def create(conn, %{"photo" => photo}) do
    current_user = current_user(conn)

    photo = Map.merge(photo, %{"user_id" => current_user(conn).id})
    changeset = Photo.changeset(%Photo{}, photo)

    if changeset.valid? do

      case Repo.insert(changeset) do
        {:ok, photo} ->
          conn
          |> put_flash(:info, "Photo saved")
          |> redirect to: user_photo_path(conn, :index, current_user)
        {:error, _} ->
          conn
          |> put_flash(:info, "Could not save the photo")
          |> redirect to: user_photo_path(conn, :new, current_user)
      end

    end

    conn |> redirect to: user_path(conn, :show, current_user)
  end

  def edit(conn, %{"id" => id}) do
    photo = Repo.get(Photo, id)

    render conn, "edit.html", photo: photo
  end

  def update(conn, %{"id" => id, "photo" => params}) do
    photo = Repo.get(Photo, id)
    changeset = Photo.changeset(photo, params)

    current_user_id = conn.assigns.current_user_id

    case photo do
      %Photo{user_id: ^current_user_id} ->
        update_photo(conn, photo, changeset)
      _ -> access_denied(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Repo.get(Photo, id)
    current_user_id = conn.assigns.current_user_id

    case photo do
      %Photo{user_id: ^current_user_id} ->
        Repo.delete(photo)

        conn
        |> put_flash(:info, "Photo deleted")
        |> redirect(to: user_photo_path(conn, :index, conn.assigns.current_user))
      _ ->
        conn
        |> put_flash(:info, "Photo not found")
        |> redirect(to: user_photo_path(conn, :index, conn.assigns.current_user))
    end
  end

  def update_photo(conn, photo, changeset) do
    case Repo.update(changeset) do
      {:ok, _photo} ->
        conn
        |> put_flash(:info, "Photo updated")
        |> redirect(
            to: user_photo_path(conn, :index, conn.assigns.current_user))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not save the photo")
        |> render("new.html", changeset: changeset)
    end
  end
end
