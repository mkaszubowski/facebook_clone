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
  plug :scrub_params, "message" when action in [:create]

  def create(conn, %{"message" => message, "conversation_id" => conversation_id}) do
    message = Map.merge(message, %{
      "user_id" => current_user(conn).id,
      "conversation_id" => conversation_id}
    )
    changeset = Message.changeset(%Message{}, message)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Message sent")
        |> redirect to: conversation_path(conn, :show, conversation_id)
      {:error, _} ->
        conn
        |> put_flash(:info, "Could not sent the message")
        |> redirect to: conversation_path(conn, :show, conversation_id)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = current_user(conn).id
    message = Repo.get(Message, id) |> Repo.preload(:conversation)
    conversation_id = message.conversation.id

    case message do
      %Message{user_id: ^current_user_id, conversation_id: ^conversation_id} ->
        Repo.delete(message)

        redirect(conn, to: conversation_path(conn, :show, conversation_id))
      _ ->
        access_denied(conn)
    end
  end
end
