defmodule FacebookClone.EventView do
  use FacebookClone.Web, :view

  def accept_link(conn, invitation) do
    link "Accept", to: event_invitation_path(conn, :update, invitation), method: :put
  end
end
