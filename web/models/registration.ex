defmodule FacebookClone.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    {status, changeset} =
      changeset
        |> put_change(:crypted_password, hashed_password(changeset.params["password"]))
        |> repo.insert

    {status, changeset}
  end

  defp hashed_password(password) do
    password
  end
end
