defmodule FacebookClone.Friendship do
  use FacebookClone.Web, :model

  alias FacebookClone.User

  schema "friendships" do
    field :accepted, :boolean, default: false

    timestamps

    belongs_to :user_one, User
    belongs_to :user_two, User
  end

  @required_fields ~w(user_one_id user_two_id)
  @optional_fields ~w(accepted)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:user_one_id_user_two_id,
                         message: "User already invited")
    |> foreign_key_constraint(:user_one_id)
    |> foreign_key_constraint(:user_two_id, message: "User does not exist")
  end

  def accepted(friendships) do
    from(f in friendships, where: f.accepted == true)
  end
end
