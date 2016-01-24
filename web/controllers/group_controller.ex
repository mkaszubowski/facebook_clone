defmodule FacebookClone.GroupController do
  use FacebookClone.Web, :controller

  alias FacebookClone.Repo
  alias FacebookClone.Group
  alias FacebookClone.Post
  alias FacebookClone.SessionHandler

  import SessionHandler, only: [current_user: 1]

  plug :scrub_params, "group" when action in [:create, :update]
  plug :find_group when action in [:edit, :update, :delete]

  def index(conn, params) do
    search = params["search"]["expression"]
    current_user = conn.assigns.current_user |> Repo.preload(:groups)
    groups = Group |> Group.search(search) |> Repo.all

    render conn, "index.html",
      groups: groups,
      search: search,
      current_user: current_user
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{})

    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    group = from(g in Group, preload: :posts) |> Repo.get(id)
    posts = get_visible_posts(conn, group)
    current_user = conn.assigns.current_user |> Repo.preload(:groups)
    post_changeset = Post.changeset(%Post{})

    render conn, "show.html",
      group: group,
      current_user: current_user,
      post_changeset: post_changeset,
      posts: posts
  end

  def create(conn, %{"group" => group}) do
    group = Map.merge(group, %{"user_id" => conn.assigns.current_user_id})
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

  def edit(conn, %{"id" => id}) do
    group = conn.assigns.group

    case group do
      %Group{} ->
        changeset = Group.changeset(group)

        render conn, "edit.html", group: group, changeset: changeset
      nil ->
        access_denied(conn)
    end
  end

  def update(conn, %{"id" => id, "group" => params}) do
    group = conn.assigns.group
    changeset = Group.changeset(group, params)

    case Repo.update(changeset) do
      {:ok, _group} ->
        conn
        |> put_flash(:info, "Group updated")
        |> redirect(to: group_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not save group")
        |> render("edit.html", group: group, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = conn.assigns.group

    case group do
      %Group{} -> handle_delete(conn, group)
      _ ->
        conn
        |> put_flash(:info, "Could not delete group")
        |> redirect(to: group_path(conn, :index))
    end
  end

  defp handle_delete(conn, group) do
    case Repo.delete(group) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Group deleted")
        |> redirect(to: group_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:info, "Could not delete group")
        |> redirect(to: group_path(conn, :index))
    end
  end

  defp get_visible_posts(conn, group) do
    conn
    |> current_user
    |> Repo.preload([:friends, :likes])
    |> Post.visible_for_user
    |> Post.for_group(group)
    |> Repo.all
  end

  defp find_group(conn, _) do
    id = conn.params["id"]
    group = conn.assigns.current_user |> assoc(:created_groups) |> Repo.get(id)

    assign(conn, :group, group)
  end
end
