defmodule FacebookClone.PostView do
  use FacebookClone.Web, :view

  alias FacebookClone.Like
  alias FacebookClone.Repo


  def post_links(conn, post, current_user_id) do
    if post.user_id == current_user_id do
      [
        link("Edit", to: post_path(conn, :edit, post)),
        link("Delete", to: post_path(conn, :delete, post), method: :delete)
      ]
    end
  end

  def like_button(conn, post, current_user_id) do
    like =
      post.likes
      |> Enum.find(fn like -> like.user_id == current_user_id end)

    case like do
      %Like{} ->
        _unlike_button(conn, like)
      _    ->
        _like_button(conn, post, current_user_id)
    end
  end

  def likes_count(post) do
    Like.count_for(post) |> Repo.one
  end

  defp _like_button(conn, post, current_user_id) do
    form_for conn, like_path(conn, :create), [as: :like], fn f ->
      [
        (text_input f, :post_id, type: :hidden, value: post.id),
        (submit "Like", class: "btn btn-primary like-button")
      ]
    end
  end

  defp _unlike_button(conn, like) do
    link "Unlike",
         to: like_path(conn, :delete, like),
         class: "btn btn-primary",
         method: :delete
  end
end
