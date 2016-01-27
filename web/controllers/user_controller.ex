defmodule FacebookClone.UserController do
  use FacebookClone.Web, :controller

  alias FacebookClone.User
  alias FacebookClone.Repo

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import FacebookClone.SessionPlug, only: [
    authenticate_current_user: 2,
    access_denied: 1
  ]

  plug :authenticate_current_user when action in [:edit, :update]
  plug :scrub_params, "user" when action in [:update]

  def index(conn, params) do
    search_expression = params["search"]["expression"]
    current_user =
      conn.assigns.current_user
      |> Repo.preload(
        [:friends, :friendship_invitations, :received_friendship_invitations])
    possible_friends_ids = User.possible_friends_ids(current_user)
    possible_friends =
      from(u in User, where: u.id in ^possible_friends_ids) |> Repo.all

    users =
      User
      |> where([u], u.id != ^current_user.id)
      |> User.search(search_expression)
      |> Repo.all

    render(conn, "index.html",
      users: users,
      search: search_expression,
      possible_friends: possible_friends,
      current_user: current_user)
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

  def get_by_id(user_id) do
    case user_id do
      nil -> nil
      _   -> Repo.get(User, user_id)
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
