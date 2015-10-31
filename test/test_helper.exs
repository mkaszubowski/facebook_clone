ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(FacebookClone.Repo)

defmodule FacebookClone.TestHelper do
  alias FacebookClone.User
  alias FacebookClone.RegistrationHandler

  use FacebookClone.ConnCase

  def create_user(email, password, first_name \\ "Foo", last_name \\ "Bar") do
    user_params = %{
      email: email,
      password: password,
      first_name: first_name,
      last_name: last_name}

    changeset = User.changeset(%User{}, user_params)
    RegistrationHandler.create(changeset, FacebookClone.Repo)
  end

  def log_in_user do
    create_user("foo@bar.com", "password")
    session_params =
      %{"session": %{"email": "foo@bar.com", "password": "password"}}

    post conn(), "/login", session_params
  end
end
