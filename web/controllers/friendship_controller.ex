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
    current_user =
      current_user(conn)
      |> Repo.preload([:friends, :received_friendship_invitations])

    friends = current_user.friends
    invited_by = current_user.received_friendship_invitations

    render(conn, "index.html", friends: friends, invited_by: [])
  end

  def delete(conn, %{"friendship" => params}) do
    friendship = Repo.get_by(
      Friendship, current_user_friendship_params(conn, params))

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

  defp current_user_friendship_params(conn, params) do
    %{
      user_id: current_user(conn).id,
      friend_id: String.to_integer(params["friend_id"])
    }
  end
end
