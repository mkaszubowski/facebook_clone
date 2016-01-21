defmodule FacebookClone.Post do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Like
  alias FacebookClone.Post
  alias FacebookClone.Group

  import Ecto.Query

  schema "posts" do
    field :content, :string

    timestamps

    belongs_to :user, User
    belongs_to :group, Group
    has_many :likes, Like, on_delete: :delete_all
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

  def visible_for_user(user) do
    visible =
      user.friends
      |> Enum.map(&(&1.id))
      |> Enum.concat([user.id])

    Post
    |> join(:inner, [p], u in User, p.user_id == u.id)
    |> where([_, u], u.id in ^visible)
    |> preload([:user, :likes])
    |> order_by(desc: :inserted_at)
    |> select([p, _], p)
  end

  def search(query, expression) do
    case expression do
      x when x == "" or is_nil(x) -> query
      _ ->
        from p in query,
          where: fragment("? % ?", p.content, ^expression)
    end
  end
end
