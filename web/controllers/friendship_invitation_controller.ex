defmodule FacebookClone.FriendshipInvitationController do
  use FacebookClone.Web, :controller

  alias FacebookClone.FriendshipInvitation
  alias FacebookClone.Repo
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]

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

  def update(conn, %{"id" => id}) do
    current_user_id = current_user(conn).id
    invitation = Repo.get(FriendshipInvitation, id)

    case invitation do
      %FriendshipInvitation{invited_id: ^current_user_id} ->
        handle_accept(conn, invitation)
      _ ->
        access_denied(conn)
    end
  end

  defp handle_accept(conn, invitation) do
    case FriendshipInvitation.accept(invitation) do
      {:ok, _}    -> message = "Friendship invitation accepted"
      {:error, _} -> message = "Could not accept friendship. Try again later"
    end

    conn
    |> put_flash(:info, message)
    |> redirect to: friendship_path(conn, :index)
  end

  defp get_invitation(conn, invitation) do
    Invitation
    |> where(user_id: ^String.to_integer(invitation["user_id"]))
    |> where(invited_id: ^current_user(conn).id)
    |> Repo.one
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
