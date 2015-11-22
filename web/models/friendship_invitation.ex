defmodule FacebookClone.FriendshipInvitation do
  use FacebookClone.Web, :model

  alias FacebookClone.User

  schema "friendship_invitations" do
    belongs_to :user, User
    belongs_to :invited, User

    timestamps
  end

  @required_fields ~w(user_id invited_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:invited_id, message: "User does not exist")
    |> unique_constraint(:user_id_invited_id, massage: "User already invited")
  end
end
