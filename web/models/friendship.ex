defmodule FacebookClone.Friendship do
  use FacebookClone.Web, :model

  alias FacebookClone.User

  schema "friendships" do
    belongs_to :user, User
    belongs_to :friend, User

    timestamps
  end

  @required_fields ~w(user_id friend_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:friend_id, message: "User does not exist")
    |> unique_constraint(:user_id_friend_id,
                         message: "User already invited")
  end
end
