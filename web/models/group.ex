defmodule FacebookClone.Group do
  use FacebookClone.Web, :model

  alias FacebookClone.Post

  schema "groups" do
    field :name, :string
    field :description, :string

    timestamps

    has_many :posts, Post
    belongs_to :user, User
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w(description)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
