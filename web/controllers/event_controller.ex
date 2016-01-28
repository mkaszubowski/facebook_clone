defmodule FacebookClone.EventController do
  use FacebookClone.Web, :controller

  alias FacebookClone.{Repo, Event, EventUser}

  plug :scrub_params, "event" when action in [:create, :update]

  def index(conn, _params) do
    current_user =
      conn.assigns.current_user
      |> Repo.preload([:events, [event_invitations: [:event, :invited_by]]])

    events = current_user.events
    invitations = current_user.event_invitations


    render conn, "index.html", events: events, invitations: invitations
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get(Event, id) |> Repo.preload(:users)

    render conn, "show.html", event: event
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"event" => event}) do
    event = Map.merge(event, %{"user_id" => conn.assigns.current_user_id})
    changeset = Event.changeset(%Event{}, event)

    case Repo.insert(changeset) do
      {:ok, event} ->
        add_user_to_event(event)

        conn
        |> put_flash(:info, "Event created")
        |> redirect(to: event_path(conn, :show, event))
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id
    event = Repo.get(Event, id)
    changeset = Event.changeset(event)

    case event do
      %Event{user_id: ^current_user_id} ->
        render conn, "edit.html", changeset: changeset, event: event
      _ ->
        access_denied(conn)
    end
  end

  def update(conn, %{"id" => id, "event" => params}) do
    current_user_id = conn.assigns.current_user_id
    event = Repo.get(Event, id)
    changeset = Event.changeset(event, params)

    case event do
      %Event{user_id: ^current_user_id} ->

        case Repo.update(changeset) do
          {:ok, _event} ->
            conn
            |> put_flash(:info, "Event updated")
            |> redirect(to: event_path(conn, :show, event))
          {:error, changeset} ->
            conn
            |> put_flash(:info, "Could not save the event")
            |> render("edit.html", changeset: changeset, event: event)
        end
      _ ->
        access_denied(conn)
    end
  end

  defp add_user_to_event(event) do
    EventUser.changeset(%EventUser{}, %{
      event_id: event.id,
      user_id: event.user_id
    }) |> Repo.insert
  end
end
