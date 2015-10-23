defmodule FacebookClone.RegistrationTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Registration
  alias FacebookClone.User
  alias FacebookClone.Repo

  @valid_attrs %{email: "foo@bar.com", password: "foobar"}

  test "saves the user when attributes are valid" do
    count = Repo.all(User) |> Enum.count

    changeset = User.changeset(%User{}, @valid_attrs)
    Registration.create(changeset, Repo)

    new_count = Repo.all(User) |> Enum.count

    assert new_count == count + 1
  end

  test "user's password is encrypted before saving" do
    changeset = User.changeset(%User{}, @valid_attrs)
    Registration.create(changeset, Repo)

    user = Repo.all(User) |> Enum.at(0)

    refute user.crypted_password == "foobar"
  end
end
