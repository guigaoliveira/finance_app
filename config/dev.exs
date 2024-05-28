import Config

config :finance_app, FinanceApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "finance_app_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :finance_app, FinanceAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "gIFeb0B8q4keUGFtJSq5TdG00q+l+NTYBUq6Zaa7ZgvyWakKyGWMWzlNY+jSHyh7",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
