defmodule FacebookClone.UserViewTest do
  use FacebookClone.ConnCase, async: true

  alias FacebookClone.User
  alias FacebookClone.Repo

  import FacebookClone.UserView, only: [full_name: 1]
  import FacebookClone.TestHelper, only: [create_user: 2]

  setup do
    {:ok, user} = create_user("foo@bar.com", "password")
    changeset = User.changeset(
      user,
      %{"first_name": "Foo", "last_name": "Bar"},
      :update)

    {:ok, user} = Repo.update(changeset)
    {:ok, user: user}
  end

  test "full_name function returns user's full name", context do
    assert full_name(context[:user]) == "Foo Bar"
  end
end
