defmodule FacebookClone.PageController do
  use FacebookClone.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
