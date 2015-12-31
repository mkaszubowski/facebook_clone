defmodule FacebookClone.MessageController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Message
  alias FacebookClone.Conversation
  alias FacebookClone.SessionPlug
  alias FacebookClone.SessionHandler

  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]
  import SessionHandler, only: [current_user: 1]

  plug :authenticate_logged_in
  plug :scrub_params when action in [:create]

  def new(conn, _params) do

    render conn, "new.html", changeset: Message.changeset(%Message{})
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get(Message, id)

    case message do
      %Message{user_id: ^current_user} ->
        Repo.delete(message)
      _ ->
        access_denied()
    end
  end
end