defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug

  import SessionPlug, only: [
    authenticate_current_user: 2,
    authenticate_logged_in: 2
  ]

  plug :authenticate_logged_in

  def create(conn, %{"friendship" => friendship}) do
    changeset = Friendship.changeset(%Friendship{}, friendship)

    case Repo.insert(changeset) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "User has been invited to your friends")
        |> redirect to: user_path(conn, :index)
      {:error, reason} ->
        conn
        |> put_flash(:info, "Cannot invite user")
        |> redirect to: user_path(conn, :index)
    end
  end
end
