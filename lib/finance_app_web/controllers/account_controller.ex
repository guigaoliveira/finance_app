defmodule FinanceAppWeb.AccountController do
  use FinanceAppWeb, :controller

  alias FinanceApp.Accounts
  alias FinanceApp.Accounts.Account
  alias FinanceAppWeb.AccountView
  alias FinanceAppWeb.Validators.AccountCreateValidator
  alias FinanceAppWeb.Validators.AccountShowValidator

  @spec show(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def create(conn, params) do
    case AccountCreateValidator.validate(params) do
      {:ok, _} ->
        %{"numero_conta" => account_number, "saldo" => balance} = params
        new_params = %{account_number: account_number, balance: balance}

        new_params
        |> Accounts.create_account()
        |> render_create_result(conn)

      {:error, _} ->
        render_create_result({:error, :validation_error}, conn)
    end
  end

  @spec show(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def show(conn, params) do
    case AccountShowValidator.validate(params) do
      {:ok, _} ->
        %{"numero_conta" => account_number} = params

        account_number
        |> Accounts.get_account_by_number()
        |> render_show_result(conn)

      {:error, _} ->
        render_show_result({:error, :validation_error}, conn)
    end
  end

  defp render_create_result({:ok, account}, conn), do: render_created(conn, account)
  defp render_create_result({:error, :validation_error}, conn), do: handle_validation_error(conn)
  defp render_create_result({:error, _}, conn), do: handle_generic_error(conn)

  defp render_show_result({:ok, account}, conn), do: render_ok(conn, account)
  defp render_show_result({:error, :account_not_found}, conn), do: render_not_found(conn)
  defp render_show_result({:error, :validation_error}, conn), do: handle_validation_error(conn)

  defp render_created(conn, %Account{} = account) do
    conn
    |> put_status(:created)
    |> put_view(AccountView)
    |> render("show.json", account: account)
  end

  defp render_ok(conn, %Account{} = account) do
    conn
    |> put_status(:ok)
    |> put_view(AccountView)
    |> render("show.json", account: account)
  end

  defp render_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Conta não encontrada"})
  end

  defp handle_validation_error(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Dados inválidos, verifique os dados enviados."})
  end

  defp handle_generic_error(conn) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Não foi possível processar a solicitação."})
  end
end
