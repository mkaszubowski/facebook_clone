defmodule FacebookClone.LikeController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Like

  import FacebookClone.SessionHandler, only: [current_user: 1]

  plug :scrub_params, "like" when action in [:create]

  def create(conn, %{"like" => like}) do
    changeset = Like.changeset(%Like{}, %{
      user_id: current_user(conn).id,
      post_id: like["post_id"]
    })

    case Repo.insert(changeset) do
      {:ok, _like} ->
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
      %Like{user_id: ^current_user_id} ->
        {:ok, _} = Repo.delete(like)
        conn |> redirect(to: post_path(conn, :index))
      _ ->
        access_denied(conn)
    end
  end
end
