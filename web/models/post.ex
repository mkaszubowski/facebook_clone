defmodule FacebookClone.Post do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Like

  schema "posts" do
    field :content, :string

    timestamps

    belongs_to :user, User
    has_many :likes, Like, on_delete: :fetch_and_delete
  end

  @required_fields ~w(user_id content)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> update_change(:content, &String.lstrip/1)
    |> validate_length(:content, min: 1, message: "Can't be blank")
    |> foreign_key_constraint(:user_id, message: "User does not exist")
  end

  def for_user(query, id) do
    from p in query,
    where: p.user_id == ^id
  end
end
