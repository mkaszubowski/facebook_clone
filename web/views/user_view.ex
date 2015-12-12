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

    friends_ids =
      [
        current_user.friendship_invitations
        |> Enum.map(fn(invitation) -> invitation.invited_id end),
        current_user.friends
        |> Enum.map(fn(friend) -> friend.id end)
      ]
      |> List.flatten

    unless Enum.member?(friends_ids, user.id), do: invite_form_tag(conn, user)
  end


  defp invite_form_tag(conn, user) do
    form_for conn, friendship_invitation_path(conn, :create),
      [as: :friendship_invitation], fn f ->
      [
        (text_input f, :invited_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary invite-user")
      ]
    end
  end
end
