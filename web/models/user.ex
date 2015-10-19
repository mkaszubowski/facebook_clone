defmodule FacebookClone.User do
  use FacebookClone.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :first_name, :string
    field :last_name, :string

    timestamps
  end

  @required_fields ~w(email crypted_password)
  @optional_fields ~w(first_name last_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
