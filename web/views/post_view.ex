defmodule FacebookClone.PostView do
  use FacebookClone.Web, :view

  def edit_button(conn, post, current_user) do
    if post.user_id == current_user.id do
      link "Edit", to: post_path(conn, :edit, post)
    end
  end

  def delete_button(conn, post, current_user) do
    if post.user_id == current_user.id do
      link "Delete", to: post_path(conn, :delete, post), method: :delete
    end
  end
end
