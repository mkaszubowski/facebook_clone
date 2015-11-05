defmodule FacebookClone.FriendshipController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Friendship
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "friendship" when action in [:create]

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

  defp current_user_friendship_params(conn, params) do
    %{
      user_one_id: current_user(conn).id,
      user_two_id: params["user_two_id"]
    }
  end

  defp error_messages(changeset) do
    changeset.errors
    |> Dict.values
    |> Enum.join(". ")
  end
end
