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
  plug :authenticate_current_user when action in [:new, :create, :edit, :update]
  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = from(p in Post, preload: [:user]) |> Repo.all

    render(conn, "index.html", posts: posts)
  end
end
