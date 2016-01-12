defmodule FacebookClone.PhotoController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Photo
  alias FacebookClone.User
  alias FacebookClone.SessionPlug
  alias FacebookClone.SessionHandler

  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]
  import SessionHandler, only: [current_user: 1]

  plug :authenticate_logged_in
  plug :scrub_params, "photo" when action in [:create]

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

  def index(conn, %{"user_id" => user_id}) do
    user = Repo.get(User, String.to_integer(user_id)) |> Repo.preload(:photos)
    photos = user.photos

    render conn, "index.html", user: user, photos: photos
  end
end
