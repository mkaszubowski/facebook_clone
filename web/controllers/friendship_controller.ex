defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug
  alias FacebookClone.User

  import FacebookClone.SessionHandler, only: [current_user: 1, current_user: 2]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "friendship" when action in [:create, :update]

  def index(conn, _params) do
    friends =
      (current_user(conn) |> Repo.preload(:friends)).friends

    render(conn, "index.html", friends: friends, invited_by: [])
  end

  def delete(conn, %{"friendship" => friendship}) do
    friendship = Repo.get_by(Friendship, friend_id: friendship["friend_id"])

    case Repo.delete(friendship) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "User deleted from friends")
        |> redirect to: friendship_path(conn, :index)
      _       ->
        conn
        |> put_flash(:info, "This user is not your friend")
        |> redirect to: friendship_path(conn, :index)
    end
  end

#   defp error_messages(changeset) do
#     changeset.errors
#     |> Dict.values
#     |> Enum.join(". ")
#   end
end
