defmodule FacebookClone.SessionHandler do
  use FacebookClone.Web, :controller

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias Plug.Conn
  alias Comeonin.Bcrypt

  def login(params, repo) do
    downcased_email = String.downcase(params["email"])
    user = repo.get_by(User, email: downcased_email)

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
