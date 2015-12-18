defmodule FacebookClone.LikeController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.User
  alias FacebookClone.Post
  alias FacebookClone.Like

  import FacebookClone.SessionHandler, only: [current_user: 1]
  import FacebookClone.SessionPlug, only: [
    access_denied: 1,
    authenticate_logged_in: 2
  ]

  plug :authenticate_logged_in
  plug :scrub_params, "like" when action in [:create]

  def create(conn, %{"like" => like}) do
    post_id = String.to_integer(like["post_id"])
    like = Ecto.build_assoc(current_user(conn), :likes, post_id: post_id)

    case Repo.insert(like) do
      {:ok, like} ->
        conn
        |> put_flash(:info, "You liked selected post")
        |> redirect(to: post_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:info, "Could not like selected post")
        |> redirect(to: post_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = current_user(conn).id
    like = Repo.get(Like, id)

    case like do
      %Like{user_id: current_user_id} ->
        {:ok, _} = Repo.delete(like)
        conn |> redirect(to: post_path(conn, :index))
      _ ->
        access_denied(conn)
    end
  end
end
