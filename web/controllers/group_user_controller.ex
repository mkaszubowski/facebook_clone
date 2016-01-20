defmodule FacebookClone.GroupUserController do
  use FacebookClone.Web, :controller

  alias FacebookClone.GroupUser

  import FacebookClone.SessionHandler, only: [current_user: 1]

  plug :get_group_user_params

  def create(conn, _) do
    changeset = GroupUser.changeset(%GroupUser{}, conn.assigns.group_user_params)

    case Repo.insert(changeset) do
      {:ok, _} -> message = "You joined the group"
      {:error, changeset} -> message = errors_for(changeset)
    end

    conn
    |> put_flash(:info, message)
    |> redirect to: group_path(conn, :index)
  end

  def delete(conn, _) do
    params = conn.assigns.group_user_params
    group_user = Repo.get_by(GroupUser, user_id: params["user_id"], group_id: params["group_id"])

    if is_nil(group_user) do
      message = "You are not in this group"
    else
      case Repo.delete(group_user) do
        {:ok, _} -> message = "You left the group"
        {:error, _} -> message = "You are not in this group"
      end
    end

    conn
    |> put_flash(:info, message)
    |> redirect to: group_path(conn, :index)
  end

  defp get_group_user_params(conn, _) do
    IO.puts(inspect conn.params["group_user"])
    params = conn.params["group_user"]
    |> Map.merge(%{"user_id" => conn.assigns.current_user_id})
    |> Enum.into(%{})

    IO.puts(inspect params)
    assign(conn, :group_user_params, params)
  end

  defp errors_for(changeset) do
    changeset.errors
    |> Dict.values
    |> Enum.join(". ")
  end
end
