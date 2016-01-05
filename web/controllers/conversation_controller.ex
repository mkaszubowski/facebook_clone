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

    render conn, "index.html",
      conversations: conversations,
      changeset: Conversation.changeset(%Conversation{})
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

  def create(conn, %{"conversation" => conversation}) do
    params = conversation_params(conn, conversation)
    message = conversation["message"]

    changeset = Conversation.changeset(%Conversation{}, params)

    case conversation = existing_conversation(params) do
      %Conversation{} ->
        send_message(conn, conversation, message)
      nil ->
        create_new_conversation(conn, changeset, message)
    end
  end

  def existing_conversation(params) do
    Conversation.between_users(params[:user_one_id], params[:user_two_id])
    |> Repo.one
  end

  def conversation_params(conn, conversation) do
    %{
      user_one_id: conversation["friend_id"],
      user_two_id: current_user(conn).id
    }
  end

  def send_message(conn, conversation, message) do
    changeset = Message.changeset(%Message{}, %{
      content: message,
      user_id: current_user(conn).id,
      conversation_id: conversation.id
    })

    case Repo.insert(changeset) do
      {:ok, _} ->
        flash = "Message sent"
      {:error, _} ->
        flash = "Could not send the message"
    end

    conn
    |> put_flash(:info, flash)
    |> redirect(to: conversation_path(conn, :show, conversation))
  end

  def create_new_conversation(conn, changeset, message) do
    case Repo.insert(changeset) do
      {:ok, conversation} ->
        send_message(conn, conversation, message)
      {:error, _} ->
        conn
        |> put_flash(:info, "Could not send the message")
        |> redirect(to: conversation_path(conn, :index))
    end
  end

  defp message_changeset(conversation) do
    Message.changeset(%Message{}, %{
      conversation_id: conversation.id
      })
  end
end
