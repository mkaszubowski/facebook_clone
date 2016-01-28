defmodule FacebookClone.EventInvitationTest do
  use FacebookClone.ModelCase

  alias FacebookClone.EventInvitation

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = EventInvitation.changeset(%EventInvitation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EventInvitation.changeset(%EventInvitation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
