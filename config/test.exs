import Config

config :finance_app, FinanceApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "finance_app_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :finance_app, FinanceAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nh5Kyd+SMUZUKgciT8BcA8PLfmPWHon2tMl91M+LqQ64e50IU/8fSGiG2a0ES74S",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
