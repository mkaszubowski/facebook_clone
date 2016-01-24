defmodule FacebookClone.EventController do
  use FacebookClone.Web, :controller

  alias FacebookClone.{Repo, Event, EventUser}

  def index(conn, _params) do
    current_user = conn.assigns.current_user |> Repo.preload(:events)
    events = current_user.events

    render conn, "index.html", events: events
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

  defp add_user_to_event(event) do
    EventUser.changeset(%EventUser{}, %{
      event_id: event.id,
      user_id: event.user_id
    }) |> Repo.insert
  end
end
