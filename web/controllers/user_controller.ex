defmodule FacebookClone.UserController do
  use FacebookClone.Web, :controller

  alias FacebookClone.User
  alias FacebookClone.Repo

  import FacebookClone.SessionPlug, only: [
    access_denied: 1,
    authenticate_current_user: 2,
    authenticate_logged_in: 2]
  import FacebookClone.SessionHandler, only: [current_user: 1, current_user: 2]

  plug :authenticate_logged_in
  plug :authenticate_current_user when action in [:edit, :update]
  plug :scrub_params, "user" when action in [:update]

  def index(conn, _params) do
    users = Repo.all(User)
    current_user = current_user(conn, :with_friends)

    render(conn, "index.html", users: users, current_user: current_user)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_flash(:info, "User not found")
        |> redirect to: user_path(conn, :index)
      user ->
        conn
        |> render "show.html", user: user
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, String.to_integer(id))
    case user do
      %User{} -> render_edit_form(conn, user)
      _       -> access_denied(conn)
    end
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Repo.get(User, id)

    case user do
      %User{} -> update_user(conn, user, params)
      _       -> access_denied(conn)
    end
  end

  defp render_edit_form(conn, user) do
    changeset = User.changeset(user)

    conn |> render "edit.html", changeset: changeset, user: user
  end

  defp update_user(conn, user, params) do
    changeset = User.changeset(user, params, :update)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated")
        |> redirect to: "/"
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not save profile")
        |> render "edit.html", changeset: changeset, user: user
    end
  end
end
