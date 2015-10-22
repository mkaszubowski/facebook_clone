defmodule FacebookClone.RegistrationController do
  use FacebookClone.Web, :controller
  alias FacebookClone.User
  alias FacebookClone.Registration

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Registration.create(changeset, FacebookClone.Repo) do
      {:ok, changeset} ->
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
