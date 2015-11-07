defmodule FacebookClone.UserView do
  use FacebookClone.Web, :view

  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  def invite_button(conn, user) do
    form_for conn, friendship_path(conn, :create), [as: :friendship], fn f ->
      html_escape([
        (text_input f, :user_two_id, type: :hidden, value: user.id),
        (submit "Invite", class: "btn btn-primary")
      ])
    end
  end
end
