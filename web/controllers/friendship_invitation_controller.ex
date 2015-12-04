defmodule FacebookClone.FriendshipInvitationController do
  use FacebookClone.Web, :controller

  alias FacebookClone.FriendshipInvitation
  alias FacebookClone.Repo
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1, current_user: 2]
  import SessionPlug, only: [authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "friendship_invitation" when action in [:create]

  def create(conn, %{"friendship_invitation" => invitation}) do
    params = current_user_invitation_params(conn, invitation)
    changeset = FriendshipInvitation.changeset(
      %FriendshipInvitation{}, params)

    case Repo.insert(changeset) do
      {:ok, _invitation} ->
        conn
        |> put_flash(:info, "User has been invited to your friends")
        |> redirect to: user_path(conn, :index)
      {:error, reason} ->
        conn
        |> put_flash(:info, error_messages(reason))
        |> redirect to: user_path(conn, :index)
    end
  end

  def update(conn, %{"friendship_invitation" => invitation}) do
    invitation = Repo.get_by(FriendshipInvitation, %{
      user_id: String.to_integer(invitation["user_id"]),
      invited_id: current_user(conn).id
    })

    case FriendshipInvitation.accept(invitation) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Friendship invitation accepted")
        |> redirect to: friendship_path(conn, :index)
      {:error, _} ->
        conn
        |> put_flash(:info, "Could not accept friendship. Try again later")
        |> redirect to: friendship_path(conn, :index)
    end
  end

  defp current_user_invitation_params(conn, invitation) do
    %{
      user_id: current_user(conn).id,
      invited_id: String.to_integer(invitation["invited_id"])
    }
  end


  defp error_messages(changeset) do
    changeset.errors
    |> Dict.values
    |> Enum.join(". ")
  end
end
