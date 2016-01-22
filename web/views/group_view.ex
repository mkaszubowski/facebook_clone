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

  def join_or_leave_link(conn, group, current_user) do
    if Enum.member?(current_user.groups, group) do
      leave_link(conn, group)
    else
      join_link(conn, group)
    end
  end

  def join_link(conn, group) do
    form_for conn, group_user_path(conn, :create), [as: :group_user], fn f ->
      [
        (text_input f, :group_id, type: :hidden, value: group.id),
        (submit "Join")
      ]
    end
  end

  def leave_link(conn, group) do
    form_for conn, group_user_path(conn, :delete, group),
      [as: :group_user, method: :delete], fn f ->
      [
        (text_input f, :group_id, type: :hidden, value: group.id),
        (submit "Leave")
      ]
    end
  end

  def submit_label(conn) do
    if Regex.match?(~r/edit/, conn.request_path), do: "Update", else: "Create"
  end
end
