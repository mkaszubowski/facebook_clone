defmodule FacebookClone.RegistrationController do
  use FacebookClone.Web, :controller
  alias FacebookClone.User
  alias FacebookClone.RegistrationHandler
  alias FacebookClone.SessionPlug

  import SessionPlug, only: [redirect_authenticated: 2]

  plug :redirect_authenticated

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case RegistrationHandler.create(changeset, FacebookClone.Repo) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "User created")
        |> redirect to: "/"
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Could not create an account")
        |> render("new.html", changeset: changeset)
    end
  end
end
