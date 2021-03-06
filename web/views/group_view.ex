defmodule FacebookClone.GroupView do
  use FacebookClone.Web, :view

  def edit_link(conn, group) do
    if group.user_id == conn.assigns.current_user_id, do:
      link("Edit", to: group_path(conn, :edit, group))
  end

  def delete_link(conn, group) do
    if group.user_id == conn.assigns.current_user_id, do:
      link("Delete", to: group_path(conn, :delete, group), method: :delete)
  end

  def delete_posts_link(conn, group) do
    if conn.assigns.current_user_id == group.user_id, do:
      link "Delete all posts", to: group_path(conn, :delete_posts, group), method: :delete
  end

  def is_member?(user, group) do
    group_ids = Enum.map(user.groups, &(&1.id))
    Enum.member?(group_ids, group.id)
  end

  def join_or_leave_link(conn, group, current_user) do
    if is_member?(current_user, group) do
      leave_link(conn, group)
    else
      join_link(conn, group)
    end
  end

  def join_link(conn, group) do
    form_for conn, group_user_path(conn, :create), [as: :group_user], fn f ->
      [
        (text_input f, :group_id, type: :hidden, value: group.id),
        (submit "Join", class: "btn btn-primary")
      ]
    end
  end

  def leave_link(conn, group) do
    form_for conn, group_user_path(conn, :delete, group),
      [as: :group_user, method: :delete], fn f ->
      [
        (text_input f, :group_id, type: :hidden, value: group.id),
        (submit "Leave", class: "btn btn-primary")
      ]
    end
  end

  def submit_label(conn) do
    if Regex.match?(~r/edit/, conn.request_path), do: "Update", else: "Create"
  end
end
