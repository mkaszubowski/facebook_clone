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
    current_user =
      current_user(conn)
      |> Repo.preload(
          [:friends,
          [friends: [posts: [:user, :likes]]],
          [posts: [:user, :likes
         ]]])

    posts =
      current_user.friends
      |> Enum.concat([current_user])
      |> Enum.map(&(&1.posts))
      |> List.flatten

    render(conn, "index.html", posts: posts, current_user_id: current_user.id)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
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
    post = get_post(conn, id)

    case post do
      %Post{} ->
        changeset = Post.changeset(post)

        conn
        |> render "edit.html", changeset: changeset, post: post
      _       ->
        access_denied(conn)
    end
  end

  def update(conn, %{"id" => id, "post" => params}) do
    case post = get_post(conn, id) do
      %Post{} -> update_post(conn, post, params)
      _       -> access_denied(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = get_post(conn, id)

    case post do
      %Post{} -> delete_post(conn, post)
      _       -> access_denied(conn)
    end
  end

  defp get_post(conn, id) do
    Post
    |> Post.for_user(current_user(conn).id)
    |> Repo.get(id)
  end

  defp update_post(conn, post, params) do
    changeset = Post.changeset(post, params)

    case Repo.update(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated")
        |> redirect to: post_path(conn, :index)
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not save the post")
        |> render("edit.html", changeset: changeset, post: post)
    end
  end

  defp delete_post(conn, post) do
    case Repo.delete(post) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Post deleted")
        |> redirect to: post_path(conn, :index)
      _        ->
        conn
        |> put_flash(:info, "Could not delete post")
        |> redirect to: post_path(conn, :index)
    end
  end
end
