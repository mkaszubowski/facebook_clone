defmodule FacebookClone.User do
  use FacebookClone.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w(first_name last_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/.*@.*\..*/)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:email)
  end
end
