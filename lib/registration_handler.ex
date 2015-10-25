defmodule FacebookClone.RegistrationHandler do
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    password = hashed_password(changeset.params["password"])

    {status, changeset} =
      changeset
        |> put_change(:crypted_password, password)
        |> repo.insert

    {status, changeset}
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
