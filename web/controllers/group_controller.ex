defmodule FacebookClone.GroupController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Group
  alias FacebookClone.SessionHandler

  import SessionHandler, only: [current_user: 1]

  plug :scrub_params, "group" when action in [:create]

  def index(conn, _params) do
    groups = Repo.all(Group)

    render conn, "index.html", groups: groups
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"group" => group}) do
    changeset = Group.changeset(%Group{}, group)

    case Repo.insert(changeset) do
      {:ok, _group} ->
        conn
        |> put_flash(:info, "Group created")
        |> redirect(to: group_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not create group")
        |> render("new.html", changeset: changeset)
    end
  end
end
