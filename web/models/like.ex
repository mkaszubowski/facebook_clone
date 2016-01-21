defmodule FacebookClone.Like do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Post
  alias FacebookClone.Like

  import Ecto.Query

  schema "likes" do
    timestamps

    belongs_to :user, User
    belongs_to :post, Post
  end

  @required_fields ~w(user_id post_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id, message: "User does not exists")
    |> foreign_key_constraint(:post_id, message: "Post does not exists")
    |> unique_constraint(:user_id_post_id,
                         message: "You've already liked this post")
  end
end
