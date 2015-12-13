defmodule FacebookClone.UserView do
  use FacebookClone.Web, :view

  alias FacebookClone.Repo

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  def invite_button(conn, user, current_user) do
    current_user = Repo.preload(
      current_user,
      [:friends, :friendship_invitations])

    pending_ids =
      current_user.friendship_invitations
      |> Enum.map(fn(invitation) -> invitation.invited_id end)

    pending = Enum.member?(pending_ids, user.id)

    friends_ids =
      current_user.friends
      |> Enum.map(fn(friend) -> friend.id end)


    if Enum.member?(friends_ids, user.id) do
      friend_label
    else
      invite_form_tag(conn, user, pending)
    end
  end


  defp invite_form_tag(conn, user, pending) when pending == false do
    form_for conn, friendship_invitation_path(conn, :create),
      [as: :friendship_invitation], fn f ->
      [
        (text_input f, :invited_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary invite-user")
      ]
    end
  end

  defp invite_form_tag(conn, user, pending) when pending == true do
    form_for conn, friendship_invitation_path(conn, :create),
      [as: :friendship_invitation], fn f ->
      [
        (text_input f, :invited_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary invite-user", disabled: true)
      ]
    end
  end

  defp friend_label do
    content_tag(:span, "Already friends", class: "friend-label")
  end

end
