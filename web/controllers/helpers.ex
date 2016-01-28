defmodule FacebookClone.Controller.Helpers do
  def error_messages(changeset) do
    changeset.errors
    |> Dict.values
    |> Enum.join(". ")
  end
end
