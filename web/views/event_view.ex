defmodule FacebookClone.EventView do
  use FacebookClone.Web, :view

  def accept_link(conn, invitation) do
    link "Accept", to: event_invitation_path(conn, :update, invitation), method: :put
  end

  def edit_link(conn, event) do
    if event.user_id == conn.assigns.current_user_id, do:
      link "Edit", to: event_path(conn, :edit, event)
  end

  def delete_link(conn, event) do
    if event.user_id == conn.assigns.current_user_id, do:
      link "Delete", to: event_path(conn, :delete, event), method: :delete
  end

  def render_form(conn, changeset) do
    render "_form.html",
      conn: conn,
      changeset: changeset,
      path: event_path(conn, :create),
      method: :post
  end

  def render_form(conn, changeset, event) do
    render "_form.html",
      conn: conn,
      changeset: changeset,
      path: event_path(conn, :update, event),
      method: :put
  end
end
