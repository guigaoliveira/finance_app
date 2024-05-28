defmodule FinanceAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :finance_app

  @session_options [
    store: :cookie,
    key: "_finance_app_key",
    signing_salt: "lEarYfVX",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :finance_app,
    gzip: false,
    only: FinanceAppWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :finance_app
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug FinanceAppWeb.Router
end
