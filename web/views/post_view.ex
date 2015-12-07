defmodule FacebookClone.PostView do
  use FacebookClone.Web, :view

  def post_links(conn, post, current_user) do
    if post.user_id == current_user.id do
      [
        link("Edit", to: post_path(conn, :edit, post)),
        link("Delete", to: post_path(conn, :delete, post), method: :delete)
      ]
    end
  end
end
