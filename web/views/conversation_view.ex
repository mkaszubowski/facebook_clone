defmodule FacebookClone.ConversationView do
  use FacebookClone.Web, :view

  import FacebookClone.UserView, only: [full_name: 1]

  def conversation_link(conn, conversation, current_user) do
    link(
      other_user_name(conversation, current_user),
      to: conversation_path(conn, :show, conversation)
    )
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
