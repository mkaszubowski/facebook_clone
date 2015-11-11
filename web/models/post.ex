defmodule FacebookClone.Post do
  use FacebookClone.Web, :model

  schema "posts" do
    field :content, :string

    timestamps

    belongs_to :user, User
  end

  @required_fields ~w(user_id content)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id, message: "User does not exist")
  end
end
