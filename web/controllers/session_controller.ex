defmodule FacebookClone.SessionController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Session

  import Session, only: [redirect_logged_user: 2]

  plug :redirect_logged_user

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
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
