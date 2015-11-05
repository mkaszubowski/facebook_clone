defmodule FacebookClone.Friendship do
  use FacebookClone.Web, :model

  schema "friendships" do
    field :user_one_id, :integer
    field :user_two_id, :integer
    field :accepted, :boolean

    timestamps
  end

  @required_fields ~w(user_one_id user_two_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> unique_constraint(:user_one_id_user_two_id,
                         message: "User already invited")
    |> foreign_key_constraint(:user_one_id)
    |> foreign_key_constraint(:user_two_id, message: "User does not exist")
  end
end
