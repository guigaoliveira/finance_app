defmodule FinanceApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FinanceAppWeb.Telemetry,
      FinanceApp.Repo,
      {DNSCluster, query: Application.get_env(:finance_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FinanceApp.PubSub},
      FinanceAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: FinanceApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    FinanceAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
