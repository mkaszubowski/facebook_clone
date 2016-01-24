defmodule FacebookClone.PostController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Post

  import FacebookClone.SessionHandler, only: [current_user: 1]

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, params) do
    search = params["search"]["expression"]
    posts = get_visible_posts(conn)

    render(conn, "index.html",
      posts: posts,
      changeset: Post.changeset(%Post{}),
      search: search
    )
  end

  def new(conn, _params) do
    render conn, "new.html", changeset: Post.changeset(%Post{})
  end

  def create(conn, %{"post" => post}) do
    post = Map.merge(post, %{"user_id" => current_user(conn).id})
    changeset = Post.changeset(%Post{}, post)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post added")
        |> redirect to: after_create_path(conn, post)
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

  defp get_visible_posts(conn) do
    search = conn.params["search"]["expression"]

    conn
    |> current_user
    |> Repo.preload([:friends, :likes])
    |> Post.visible_for_user
    |> Post.search(search)
    |> Repo.all
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
      {:ok, _} -> message = "Post deleted"
      _        -> message = "Could not delete post"
    end

    conn
    |> put_flash(:info, "Post deleted")
    |> redirect to: post_path(conn, :index)
  end

  defp after_create_path(conn, post) do
    case post.group_id do
      nil -> post_path(conn, :index)
      id -> group_path(conn, :show, id)
    end
  end
end
