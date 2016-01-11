defmodule FacebookClone.Photo do
  use FacebookClone.Web, :model
  use Arc.Ecto.Model

  alias FacebookClone.User
  alias FacebookClone.PhotoFile

  import Ecto.Query

  schema "photos" do
    field :description, :string
    field :photo_file, PhotoFile.Type

    timestamps

    belongs_to :user, User
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(description)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, [], ~w(photo_file))
    |> foreign_key_constraint(:user_id, message: "User does not exist")
  end

  def for_user(query, id) do
    from p in query,
    where: p.user_id == ^id
  end

end
