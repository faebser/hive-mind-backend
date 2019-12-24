use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hive_backend, HiveBackendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :hive_backend, HiveBackend.Repo,
  username: "postgres",
  password: "postgres",
  database: "hive_backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
