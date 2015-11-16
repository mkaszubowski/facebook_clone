defmodule FacebookClone.RegistrationHandler do
  import Ecto.Changeset, only: [put_change: 3]

  alias Comeonin.Bcrypt

  def create(changeset, repo) do
    case changeset.params["password"] do
      nil ->
        {:error, changeset}
      _   ->
        password = hashed_password(changeset.params["password"])

        {status, changeset} =
          changeset
          |> put_change(:crypted_password, password)
          |> repo.insert

        {status, changeset}
    end
  end

  defp hashed_password(password) do
    Bcrypt.hashpwsalt(password)
  end
end
