import Config

config :finance_app,
  ecto_repos: [FinanceApp.Repo],
  generators: [timestamp_type: :utc_datetime]

config :finance_app, FinanceAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: FinanceAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FinanceApp.PubSub,
  live_view: [signing_salt: "qOo7UM/z"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :finance_app, FinanceApp.Repo, migration_primary_key: [type: :uuid]

config :finance_app,
  company_account_number: 1,
  credit_tax: 0.05,
  debit_tax: 0.03

import_config "#{config_env()}.exs"
