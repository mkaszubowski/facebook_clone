use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :facebook_clone, FacebookClone.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :facebook_clone, FacebookClone.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "test",
  password: "test",
  database: "facebook_clone_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
