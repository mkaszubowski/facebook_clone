defmodule FacebookClone.ConversationController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.User
  alias FacebookClone.Conversation

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import SessionPlug, only: [access_denied: 1, authenticate_logged_in: 2]

  plug :authenticate_logged_in

  def create(conn, %{"conversation" => conversation}) do

  end
end
