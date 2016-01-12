defmodule FacebookClone.SessionPlug do
  use Phoenix.Controller

  alias Plug.Conn
  alias FacebookClone.SessionHandler

  import FacebookClone.Router.Helpers

  def redirect_authenticated(conn, _args) do
    case SessionHandler.logged_in?(conn) do
      true ->
        conn
        |> put_flash(:info, "You are already logged in")
        |> redirect to: "/"
      false ->
        conn
    end
  end

  def access_denied(conn) do
    access_denied(conn, "You don't have access to this page")
  end

  def access_denied(conn, message) do
    case SessionHandler.logged_in?(conn) do
      true ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: "/")
        |> halt
      false ->
        conn
        |> put_flash(:info, "You have to sign in first")
        |> redirect(to: session_path(conn, :new))
        |> halt
    end
  end

  def authenticate_logged_in(conn, _params) do
    case SessionHandler.logged_in?(conn) do
      true -> conn
      false ->
        conn
        |> put_flash(:info, "You have to sign in first")
        |> redirect(to: session_path(conn, :new))
        |> halt
    end
  end

  def authenticate_current_user(conn, _params) do
    user_id = conn.params["id"] |> String.to_integer

    authenticate_logged_in(conn, [])

    case SessionHandler.current_user(conn).id == user_id do
      true -> conn
      false -> access_denied(conn)
    end
  end

  def authorize_user(conn, user_id_param_key) do
    user_id = conn.params[user_id_param_key] |> String.to_integer

    authenticate_logged_in(conn, [])

    case SessionHandler.current_user(conn).id == user_id do
      true -> conn
      false -> access_denied(conn)
    end
  end
end
