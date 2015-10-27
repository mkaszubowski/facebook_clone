defmodule FacebookClone.SessionPlug do
  use FacebookClone.Web, :controller

  alias Plug.Conn

  import FacebookClone.Router.Helpers
  import FacebookClone.SessionHandler, only: [logged_in?: 1]

  def redirect_authenticated(
    %Conn{method: method} = conn,
    [skip_method: method]
  ), do: conn
  def redirect_authenticated(conn, _args) do
    case logged_in?(conn) do
      true ->
        conn
        |> put_flash(:info, "You are already logged in")
        |> redirect to: "/"
      false ->
        conn
    end
  end

  def authenticate_user(conn) do
    case logged_in?(conn) do
      true -> conn
      false ->
        conn
        |> put_flash(:info, "You have to sign in first")
        |> redirect to: session_path(conn, :new)
    end
  end

end
