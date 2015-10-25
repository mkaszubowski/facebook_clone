defmodule FacebookClone.SessionHandlerHandlerTest do
  use FacebookClone.ModelCase

  alias FacebookClone.SessionHandler
  alias FacebookClone.RegistrationHandler
  alias FacebookClone.User
  alias FacebookClone.Repo

  @valid_attrs %{"email" => "foo@bar.com", "password" => "foobar"}
  @invalid_attrs %{"email" => "foo@bar.com", "password" => "invalid"}

  defp create_user do
    changeset = User.changeset(%User{}, @valid_attrs)
    RegistrationHandler.create(changeset, Repo)
  end

  test "returns {:ok, user} when given valid email and password" do
    create_user

    {status, user} = SessionHandler.login(@valid_attrs, Repo)

    assert status == :ok
    assert user == Repo.all(User) |> Enum.at(0)
  end

  test "returns :error when given invalid email or password" do
    create_user

    status = SessionHandler.login(@invalid_attrs, Repo)

    assert status == :error
  end

  test "current_user returns signed in user" do
    create_user
    user = Repo.all(User) |> Enum.at(0)


  end
end
