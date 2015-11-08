defmodule FacebookClone.UserView do
  use FacebookClone.Web, :view

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  def invite_button(conn, user, current_user) do
    friends_ids =
      current_user.friends
      |> Enum.map(fn(friend) -> friend.id end)

    unless Enum.member?(friends_ids, user.id), do: invite_form_tag(conn, user)
  end


  defp invite_form_tag(conn, user) do
    form_for conn, friendship_path(conn, :create), [as: :friendship], fn f ->
      [
        (text_input f, :user_two_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary")
      ]
    end
  end
end
