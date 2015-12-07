defmodule FacebookClone.PostController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.User
  alias FacebookClone.Post
  alias FacebookClone.SessionPlug

  import FacebookClone.SessionHandler, only: [current_user: 1, current_user: 2]
  import FacebookClone.SessionPlug, only: [
    access_denied: 1,
    authenticate_current_user: 2,
    authenticate_logged_in: 2]

  plug :authenticate_logged_in
  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = from(p in Post, preload: [:user]) |> Repo.all

    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"post" => post}) do
    post = Map.merge(post, %{"user_id" => current_user(conn).id})
    changeset = Post.changeset(%Post{}, post)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post added")
        |> redirect to: post_path(conn, :index)
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not save the post")
        |> render("new.html", changeset: changeset)

    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = current_user(conn).id
    post =
      from(p in Post, where: p.user_id == ^current_user_id)
      |> Repo.get(id)

    case post do
      %Post{} ->
        changeset = Post.changeset(post)

        conn
        |> render "edit.html", changeset: changeset, post: post
      _       ->
        access_denied(conn)
    end
  end
end
