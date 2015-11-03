defmodule FacebookClone.User do
  use FacebookClone.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string
    field :city, :string
    field :birthday, Ecto.Date
    field :gender, :integer

    timestamps
  end

  @required_fields ~w(email password first_name last_name)
  @optional_fields ~w(city birthday gender)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params, :update) do
    model
    |> cast(params, ~w(first_name last_name), @optional_fields)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/.*@.*\..*/)
    |> validate_length(:password, min: 6)
    |> validate_inclusion(:gender, 0..1)
    |> unique_constraint(:email)
  end
end
