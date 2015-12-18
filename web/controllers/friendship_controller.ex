defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug
  alias FacebookClone.User

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "friendship" when action in [:create, :update]

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

  def delete(conn, %{"friendship" => params}) do
    friendship = Repo.get_by(
      Friendship, current_user_friendship_params(conn, params))

    case delete_with_reversed(friendship) do
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

  defp current_user_friendship_params(conn, params) do
    %{
      user_id: current_user(conn).id,
      friend_id: String.to_integer(params["friend_id"])
    }
  end

  defp delete_with_reversed(friendship) do
    reversed_friendship = Repo.get_by(
      Friendship, reversed_friendship_params(friendship)
    )

    Repo.transaction(fn ->
      {:ok, _} = Repo.delete(friendship)

      unless is_nil(reversed_friendship),
      do: {:ok, _} = Repo.delete(reversed_friendship)
    end)
  end

  defp reversed_friendship_params(friendship) do
    %{
      user_id: friendship.friend_id,
      friend_id: friendship.user_id
    }
  end
end
