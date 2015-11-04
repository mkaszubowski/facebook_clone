defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in

  def create(conn, %{"friendship" => friendship}) do
    params = %{
      "user_one_id": current_user(conn).id,
      "user_two_id": friendship["user_two_id"],
    }
    changeset = Friendship.changeset(%Friendship{}, friendship)

    case Repo.insert(changeset) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "User has been invited to your friends")
        |> redirect to: user_path(conn, :index)
      {:error, _reason} ->
        conn
        |> put_flash(:info, "Cannot invite that user")
        |> redirect to: user_path(conn, :index)
    end
  end
end
