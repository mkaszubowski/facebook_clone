defmodule FacebookClone.ConversationView do
  use FacebookClone.Web, :view

  alias FacebookClone.Message
  alias FacebookClone.Repo

  import FacebookClone.UserView, only: [full_name: 1]

  def conversation_link(conn, conversation, current_user) do
    link(
      other_user_name(conversation, current_user),
      to: conversation_path(conn, :show, conversation)
    )
  end

  def delete_link(conn, conversation, message) do
    if can_delete_message?(conn, conversation, message) do
      link(
        "delete",
        to: conversation_message_path(conn, :delete, conversation, message),
        method: :delete
      )
    end
  end

  defp can_delete_message?(conn, conversation, message) do
    current_user = current_user(conn)

    newer_count =
      message
      |> Message.newer_for_conversation_count(conversation)
      |> Repo.one

    message.user_id == current_user.id && newer_count == 0
  end

  defp other_user(conversation, current_user) do
    if current_user.id == conversation.user_one_id do
      conversation.user_two
    else
      conversation.user_one
    end
  end

  defp other_user_name(conversation, current_user) do
    conversation
    |> other_user(current_user)
    |> full_name
  end
end
