defmodule FacebookClone.EventInvitationController do
  use FacebookClone.Web, :controller

  alias FacebookClone.{Repo, Event, EventInvitation, EventUser}

  def create(conn, %{"event_id" => event_id, "invitation" => invitation}) do
    event = Repo.get(Event, event_id)

    changeset = EventInvitation.changeset(%EventInvitation{}, %{
      event_id: event_id,
      user_id: invitation["user_id"],
      invited_by_id: conn.assigns.current_user_id
    })

    case Repo.insert(changeset) do
      {:ok, _invitation} ->
        conn
        |> put_flash(:conn, "User invited")
        |> redirect(to: event_path(conn, :show, event))
      {:error, changeset} ->
        conn
        |> put_flash(:conn, error_messages(changeset))
        |> redirect(to: event_path(conn, :show, event))
    end
  end

  def update(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    invitation = Repo.get(EventInvitation, id)
    changeset = EventUser.changeset(%EventUser{}, %{
      event_id: invitation.event_id,
      user_id: invitation.user_id
    })

    case invitation do
      %EventInvitation{user_id: ^current_user_id} ->
        Repo.transaction fn ->
          {:ok, _} = Repo.delete(invitation)
          {:ok, _} = Repo.insert(changeset)
        end

        conn
        |> put_flash(:info, "You joined the event")
        |> redirect(to: event_path(conn, :show, invitation.event_id))

      _ ->
        access_denied(conn)
    end

  end
end
