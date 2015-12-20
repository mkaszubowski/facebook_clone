defmodule FacebookClone.FriendshipView do
  use FacebookClone.Web, :view

  import FacebookClone.UserView, only: [full_name: 1]

  def accept_button(conn, invitation) do
    link "Accept",
         to: friendship_invitation_path(conn, :update, invitation),
         class: "btn btn-primary",
         method: :put
  end

  def remove_friend_button(conn, friend) do
    link "Remove",
         to: friendship_path(conn, :delete, friend),
         class: "btn btn-primary",
         method: :delete
  end
end
