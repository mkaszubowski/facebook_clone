ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(FacebookClone.Repo)

defmodule FacebookClone.TestHelper do
  alias FacebookClone.User
  alias FacebookClone.Friendship
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

  def create_friendship do
    {:ok, user} = create_user("foo-1@bar.com", "password")
    {:ok, friend} = create_user("foo-2@bar.com", "password")

    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user.id,
      friend_id: friend.id
    })
    friendship = Repo.insert!(changeset)

    {user, friend, friendship}
  end

  def create_friendship(user, friend) do
    IO.puts(inspect(user))
    IO.puts(inspect(friend))
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user.id,
      friend_id: friend.id
    })
    friendship = Repo.insert!(changeset)

    {user, friend, friendship}
  end
end
