defmodule FacebookClone.SessionPlug do
  use Phoenix.Controller

  alias Plug.Conn
  alias FacebookClone.SessionHandler

  import FacebookClone.Router.Helpers

  def redirect_authenticated(
    %Conn{method: method} = conn,
    [skip_method: method]
  ), do: conn
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
        |> redirect to: "/"
      false ->
        conn
        |> put_flash(:info, message)
        |> redirect to: session_path(conn, :new)
    end
  end

  def authenticate_user(conn, [user: user]) do
    case SessionHandler.current_user(conn) == user do
      true -> conn
      false ->
        access_denied(conn)
    end
  end

  def authenticate_user(conn, _params) do
    case SessionHandler.logged_in?(conn) do
      true -> conn
      false ->
        conn
        |> put_flash(:info, "You have to sign in first")
        |> redirect to: session_path(conn, :new)
    end
  end

end
