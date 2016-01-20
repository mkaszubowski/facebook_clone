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
end
