defmodule FacebookClone.SessionController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.SessionHandler
  alias FacebookClone.SessionPlug

  import SessionPlug, only: [redirect_authenticated: 2]

  plug :redirect_authenticated when action in [:new, :create]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case SessionHandler.login(session_params, Repo) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect to: "/"
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render "new.html"
    end
  end

  def delete(conn, _params) do
    conn
    |> put_session(:current_user_id, nil)
    |> put_flash(:info, "User logged out")
    |> redirect to: "/"
  end
end
