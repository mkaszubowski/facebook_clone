defmodule FacebookClone.MessageView do
  use FacebookClone.Web, :view

  alias FacebookClone.Repo

  import FacebookClone.UserView, only: [full_name: 1]

  def friends_select_options(conn) do
    current_user = current_user(conn) |> Repo.preload(:friends)
    friends = current_user.friends

    Enum.map(friends, fn f -> {full_name(f), f.id} end)
  end
end
