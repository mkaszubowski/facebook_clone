defmodule FacebookClone.UserView do
  use FacebookClone.Web, :view

  alias FacebookClone.Repo

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  def gender(user) do
    if user.gender == 1, do: "Male", else: "Female"
  end

  def random_photo_path(user) do
    user = user |> Repo.preload(:photos)

    case photos = user.photos do
      [] ->
        ""
      _ ->
        :random.seed(:os.timestamp)
        photos
        |> Enum.shuffle
        |> hd
        |> FacebookClone.PhotoView.photo_path
    end
  end

  def invite_button(conn, user, current_user) do
    pending_ids =
      current_user.friendship_invitations
      |> Enum.map(&(&1.invited_id))

    received_invitation_ids =
      current_user.received_friendship_invitations
      |> Enum.map(&(&1.user_id))

    pending =
      Enum.member?(pending_ids, user.id) ||
        Enum.member?(received_invitation_ids, user.id)

    friends_ids =
      current_user.friends
      |> Enum.map(fn(friend) -> friend.id end)

    if Enum.member?(friends_ids, user.id) do
      friend_label
    else
      invite_form_tag(conn, user, pending)
    end
  end


  defp invite_form_tag(conn, user, pending) do
    form_for conn, friendship_invitation_path(conn, :create),
      [as: :friendship_invitation], fn f ->
      [
        (text_input f, :invited_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary invite-user", disabled: pending)
      ]
    end
  end

  defp friend_label do
    content_tag(:span, "Already friends", class: "friend-label")
  end

end
