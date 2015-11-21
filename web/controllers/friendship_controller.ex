defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug
  alias FacebookClone.User

  import FacebookClone.SessionHandler, only: [current_user: 1, current_user: 2]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "friendship" when action in [:create, :update]

  def index(conn, _params) do
    friends =
      conn
      |> current_user
      |> User.friends
    invited_by =
      conn
      |> current_user
      |> User.invited_by

    render(conn, "index.html", friends: friends, invited_by: invited_by)
  end

  def create(conn, %{"friendship" => friendship}) do
    params = current_user_friendship_params(conn, friendship)
    changeset = Friendship.changeset(%Friendship{}, params)

    case Repo.insert(changeset) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "User has been invited to your friends")
        |> redirect to: user_path(conn, :index)
      {:error, reason} ->
        conn
        |> put_flash(:info, error_messages(reason))
        |> redirect to: user_path(conn, :index)
    end
  end

  def update(conn, %{"friendship" => friendship}) do
    user_one_id = friendship["user_one_id"]
    user_two_id = current_user(conn).id

    case Repo.get_by(Friendship, user_one_id: user_one_id, user_two_id: user_two_id) do
      nil ->
        conn
        |> put_flash(:info, "You have not been invited by that user")
        |> redirect to: friendship_path(conn, :index)
      friendship ->
        accept_friendship(conn, friendship)
    end
  end

  def delete(conn, %{"id" => id}) do
    friendship = Repo.get(Friendship, id)

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

  defp current_user_friendship_params(conn, friendship) do
    %{
      user_one_id: current_user(conn).id,
      user_two_id: String.to_integer(friendship["user_two_id"])
    }
  end

  defp error_messages(changeset) do
    changeset.errors
    |> Dict.values
    |> Enum.join(". ")
  end

  defp accept_friendship(conn, friendship) do
    changeset = Friendship.changeset(friendship, %{accepted: true})

    case Repo.update(changeset) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "You have accepted this friend")
        |> redirect to: friendship_path(conn, :index)
      _ ->
        conn
        |> put_flash(:info, "An error occurred. Try again later.")
        |> redirect to: friendship_path(conn, :index)
    end
  end
end
