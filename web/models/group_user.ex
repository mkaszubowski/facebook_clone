defmodule FacebookClone.GroupUser do
  use FacebookClone.Web, :model

  alias FacebookClone.Repo
  alias FacebookClone.User
  alias FacebookClone.Group

  schema "group_users" do
    belongs_to :user, User
    belongs_to :group, Group

    timestamps
  end

  @required_fields ~w(user_id group_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:group_id)
    |> unique_constraint(:user_id_group_id, message: "You already are in this group")
  end
end
