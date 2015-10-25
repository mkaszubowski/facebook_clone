defmodule FacebookClone.SessionController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.SessionHandler

  import SessionHandler, only: [logged_in?: 1, redirect_logged_user: 2]


  def new(conn, _params) do
    if logged_in?(conn), do: redirect_logged_user(conn, [])

    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    if logged_in?(conn), do: redirect_logged_user(conn, [])

    case SessionHandler.login(session_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
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
    |> put_session(:current_user, nil)
    |> put_flash(:info, "User logged out")
    |> redirect to: "/"
  end
end
