defmodule FacebookClone.Session do
  alias FacebookClone.User

  def login(params, repo) do
    downcased_email = String.downcase(params["email"])
    user = repo.get_by(User, email: downcased_email)

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end
