defmodule FacebookClone.ConversationController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Conversation
  alias FacebookClone.Message
  alias FacebookClone.SessionPlug
  alias FacebookClone.SessionHandler

  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]
  import SessionHandler, only: [current_user: 1]

  plug :authenticate_logged_in

  def index(conn, _params) do
    conversations =
      conn
      |> current_user
      |> Conversation.for_user
      |> Repo.all

    render conn, "index.html", conversations: conversations
  end

  def show(conn, %{"id" => id}) do
    conversation =
      conn
      |> current_user
      |> Conversation.for_user
      |> where(id: ^id)
      |> Repo.one

    messages =
      conversation
      |> Message.for_conversation
      |> Repo.all

    render conn, "show.html",
      conversation: conversation,
      messages: messages,
      changeset: message_changeset(conversation)
  end

  defp message_changeset(conversation) do
    Message.changeset(%Message{}, %{
      conversation_id: conversation.id
      })
  end
end
