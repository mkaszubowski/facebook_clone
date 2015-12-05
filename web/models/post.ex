defmodule FacebookClone.Post do
  use FacebookClone.Web, :model

  alias FacebookClone.User

  schema "posts" do
    field :content, :string

    timestamps

    belongs_to :user, User
  end

  @required_fields ~w(user_id content)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> update_change(:content, &String.lstrip/1)
    |> validate_length(:content, min: 1, message: "Can't be blank")
    |> foreign_key_constraint(:user_id, message: "User does not exist")
  end
end
