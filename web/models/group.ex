defmodule FacebookClone.Group do
  use FacebookClone.Web, :model

  schema "groups" do
    field :name, :string
    field :description, :string

    timestamps

    has_many :posts, Post
  end

  @required_fields ~w(name)
  @optional_fields ~w(description)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
