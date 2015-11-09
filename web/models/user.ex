defmodule FacebookClone.User do
  use FacebookClone.Web, :model

  alias FacebookClone.Repo
  alias FacebookClone.Friendship

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

    has_many :pending_friendships, Friendship, foreign_key: :user_one_id
    has_many :pending_friends, through: [:pending_friendships, :user_two]

    # has_many :friendships, from(f in Friendship, where: f.accepted == true), foreign_key: :user_one_id
  end

  @required_fields ~w(email password first_name last_name)
  @update_required_fields ~w(first_name last_name)
  @optional_fields ~w(city birthday gender)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params, :update) do
    model
    |> cast(params, @update_required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> check_validations
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> check_validations
  end

  defp check_validations(changeset) do
    changeset
    |> validate_format(:email, ~r/.*@.*\..*/)
    |> validate_length(:password, min: 6)
    |> validate_inclusion(:gender, 0..1)
    |> unique_constraint(:email)
  end

  def friendships(user) do
    user
    |> assoc(:pending_friendships)
    |> Friendship.accepted
  end

  def friends(user) do
    from(
      f in friendships(user),
      preload: :user_two
    )
    |> Repo.all
    |> Enum.map(&(&1.user_two))
  end
end
