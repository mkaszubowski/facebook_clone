defmodule FacebookClone.SessionHandler do
  use FacebookClone.Web, :controller

  alias FacebookClone.User
  alias FacebookClone.Repo

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

  def logged_in?(conn), do: !!current_user(conn)

  def redirect_logged_user(conn, _) do
    case logged_in?(conn) do
      true ->
        conn
        |> put_flash(:info, "You are already logged in")
        |> redirect to: "/"
      false ->
        conn
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
