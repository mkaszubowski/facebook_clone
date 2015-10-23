defmodule FacebookClone.SessionTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Session
  alias FacebookClone.Registration
  alias FacebookClone.User
  alias FacebookClone.Repo

  @valid_attrs %{"email" => "foo@bar.com", "password" => "foobar"}
  @invalid_attrs %{"email" => "foo@bar.com", "password" => "invalid"}

  defp create_user do
    changeset = User.changeset(%User{}, @valid_attrs)
    Registration.create(changeset, Repo)
  end

  test "returns {:ok, user} when given valid email and password" do
    create_user

    {status, user} = FacebookClone.Session.login(@valid_attrs, Repo)

    assert status == :ok
    assert user == Repo.all(User) |> Enum.at(0)
  end

  test "returns :error when given invalid email or password" do
    create_user

    status = FacebookClone.Session.login(@invalid_attrs, Repo)

    assert status == :error
  end
end
