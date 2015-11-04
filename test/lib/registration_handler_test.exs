defmodule FacebookClone.RegistrationHandlerTest do
  use FacebookClone.ModelCase

  alias FacebookClone.RegistrationHandler
  alias FacebookClone.User
  alias FacebookClone.Repo

  @valid_attrs %{email: "foo@bar.com", password: "foobar", first_name: "Foo", last_name: "Bar"}
  @blank_attrs %{}

  test "saves the user when attributes are valid" do
    count = Repo.all(User) |> Enum.count

    changeset = User.changeset(%User{}, @valid_attrs)
    RegistrationHandler.create(changeset, Repo)

    new_count = Repo.all(User) |> Enum.count

    assert new_count == count + 1
  end

  test "user's password is encrypted before saving" do
    changeset = User.changeset(%User{}, @valid_attrs)
    RegistrationHandler.create(changeset, Repo)

    user = Repo.all(User) |> Enum.at(0)

    refute user.crypted_password == "foobar"
  end

  test "returns error when email is already taken" do
    changeset = User.changeset(%User{}, @valid_attrs)
    RegistrationHandler.create(changeset, Repo)

    {status, _changeset} = RegistrationHandler.create(changeset, Repo)

    assert status == :error
  end

  test "return errors when required attributes are blank" do
    changeset = User.changeset(%User{}, @blank_attrs)
    {status, changeset} = RegistrationHandler.create(changeset, Repo)


    assert status == :error

    [:email, :password, :first_name, :last_name]
    |> Enum.each(fn (field) ->
        assert {field, "can't be blank"} in changeset.errors
      end)
  end
end
