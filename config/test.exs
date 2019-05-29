use Mix.Config

# Configure your database
config :todo_api, TodoApi.Repo,
  username: "serradura",
  password: "",
  database: "todo_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_api, TodoApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12
