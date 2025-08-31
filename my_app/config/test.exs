use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :my_app, MyApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :my_app, MyApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "my_app",
  password: "postgres",
  database: "my_app_test",
  hostname: "127.0.0.1",
  pool: Ecto.Adapters.SQL.Sandbox
