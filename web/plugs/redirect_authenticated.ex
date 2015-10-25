defmodule FacebookClone.RedirectAuthenticated do
  use FacebookClone.Web, :controller

  alias Plug.Conn

  import FacebookClone.SessionHandler, only: [logged_in?: 1]

  def redirect_authenticated(
    %Conn{method: method} = conn,
    [skip_method: method]
  ), do: conn
  def redirect_authenticated(conn, args) do
    case logged_in?(conn) do
      true ->
        conn
        |> put_flash(:info, "You are already logged in")
        |> redirect to: "/"
      false ->
        conn
    end
  end

end
