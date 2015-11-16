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

    has_many :sent_friendships,
             Friendship,
             foreign_key: :user_one_id,
             on_delete: :fetch_and_delete
    has_many :received_friendships,
             Friendship,
             foreign_key: :user_two_id,
             on_delete: :fetch_and_delete
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

  defp check_validations(model) do
    model
    |> validate_format(:email, ~r/.*@.*\..*/)
    |> validate_length(:password, min: 6)
    |> validate_inclusion(:gender, 0..1)
    |> unique_constraint(:email)
  end

  def friendships(user) do
    user
    |> assoc(:sent_friendships)
    |> Friendship.accepted
  end

  def friends(user) do
    from(f in friendships(user), preload: :user_two)
    |> Repo.all
    |> Enum.map(&(&1.user_two))
  end

  def not_accepted_friendships(user) do
    user
    |> assoc(:sent_friendships)
    |> Friendship.not_accepted
  end

  def invited_by(user) do
    from(f in not_accepted_friendships(user), preload: :user_two)
    |> Repo.all
    |> Enum.map(&(&1.user_two))
  end
end
