defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]

  plug :authenticate_logged_in

  def index(conn, _params) do
    current_user =
      current_user(conn)
      |> Repo.preload([:friends, :received_friendship_invitations])

    friends = current_user.friends
    invited_by =
      current_user.received_friendship_invitations
      |> Repo.preload(:user)

    render(conn, "index.html", friends: friends, invited_by: invited_by)
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = current_user(conn).id
    friendship = Repo.get(Friendship, id)

    case friendship do
      %Friendship{user_id: ^current_user_id} ->
        process_delete(conn, friendship)
      _ ->
        access_denied(conn)
    end
  end

  defp process_delete(conn, friendship) do
    case Friendship.delete_with_reversed(friendship) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User deleted from friends")
        |> redirect to: friendship_path(conn, :index)
      _       ->
        conn
        |> put_flash(:info, "This user is not your friend")
        |> redirect to: friendship_path(conn, :index)
    end
  end
end
