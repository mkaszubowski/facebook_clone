defmodule FacebookClone.FriendshipView do
  use FacebookClone.Web, :view

  import FacebookClone.UserView, only: [full_name: 1]

  def accept_button(conn, invitation) do
    form_for conn, friendship_invitation_path(conn, :update, invitation),
             [as: :friendship_invitation, method: :put], fn f ->
      [
        (text_input f, :user_id, type: :hidden, value: invitation.user_id),
        (submit "Accept", class: "btn btn-primary")
      ]
    end
  end

  def remove_friend_button(conn, friend) do
    form_for conn, friendship_path(conn, :delete, friend),
             [as: :friendship, method: :delete], fn f ->
      [
        (text_input f, :friend_id, type: :hidden, value: friend.id),
        (submit "Remove", class: "btn btn-primary")
      ]
    end
  end
end
