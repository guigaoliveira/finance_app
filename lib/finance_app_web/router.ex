defmodule FinanceAppWeb.Router do
  use FinanceAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FinanceAppWeb do
    pipe_through :api

    post "/conta", AccountController, :create
    get "/conta", AccountController, :show

    post "/transacao", OperationController, :create
  end
end
