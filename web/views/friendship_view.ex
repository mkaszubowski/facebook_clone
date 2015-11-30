defmodule FacebookClone.FriendshipView do
  use FacebookClone.Web, :view

  import FacebookClone.UserView, only: [full_name: 1]

  def accept_button(conn, invited_by) do
    form_for conn, friendship_path(conn, :update, invited_by),
             [as: :friendship, method: :put], fn f ->
      [
        (text_input f, :user_one_id, type: :hidden, value: invited_by.id),
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
