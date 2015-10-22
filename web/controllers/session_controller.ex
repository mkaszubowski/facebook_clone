defmodule FacebookClone.SessionController do
  use FacebookClone.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case FacebookClone.Session.login(session_params, FacebookClone.Repo) do
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
