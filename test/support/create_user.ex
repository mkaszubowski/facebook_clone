defmodule FacebookClone.CreateUser do
  alias FacebookClone.User
  alias FacebookClone.RegistrationHandler

  def create_user(email, password) do
    user_params = %{email: email, password: password}
    changeset = User.changeset(%User{}, user_params)
    RegistrationHandler.create(changeset, FacebookClone.Repo)
  end

end
