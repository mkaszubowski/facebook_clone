defmodule FacebookClone.SessionHandler do
  use FacebookClone.Web, :controller

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias Plug.Conn

  def login(params, repo) do
    downcased_email = String.downcase(params["email"])
    user = repo.get_by(User, email: downcased_email)

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Repo.get(User, id)
  end

  def current_user(conn, :with_friends) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: (from u in User, preload: [:pending_friendships]) |> Repo.get(id)
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
