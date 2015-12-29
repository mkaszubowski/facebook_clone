defmodule FacebookClone.ConversationView do
  use FacebookClone.Web, :view

  import FacebookClone.UserView, only: [full_name: 1]

  def other_user(conversation, current_user) do
    if current_user.id == conversation.user_one_id do
      conversation.user_two
    else
      conversation.user_one
    end
  end
end
