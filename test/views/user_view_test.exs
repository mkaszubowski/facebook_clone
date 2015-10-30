defmodule FacebookClone.UserViewTest do
  use FacebookClone.ConnCase, async: true

  alias FacebookClone.User
  alias FacebookClone.Repo

  import FacebookClone.UserView, only: [full_name: 1]
  import FacebookClone.CreateUser, only: [create_user: 2]

  test "full_name function returns user's full name" do
    {:ok, user} = create_user("foo@bar.com", "password")
    changeset = User.changeset(
      user,
      %{"first_name": "Foo", "last_name": "Bar"},
      :update)
    {:ok, user} = Repo.update(changeset)

    assert full_name(user) == "Foo Bar"
  end
end
