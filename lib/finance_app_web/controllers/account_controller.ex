defmodule FinanceAppWeb.AccountController do
  use FinanceAppWeb, :controller

  alias FinanceApp.Accounts
  alias FinanceApp.Accounts.Account
  alias FinanceAppWeb.AccountView
  alias FinanceAppWeb.Validators.AccountCreateValidator
  alias FinanceAppWeb.Validators.AccountShowValidator

  @doc """
  Create a new account.
  """
  def create(conn, params) do
    case AccountCreateValidator.validate(params) do
      {:ok, validated_params} ->
        create_account(conn, validated_params)

      {:error, _} ->
        render_validation_error(conn)
    end
  end

  @doc """
  Show account details by account number.
  """
  def show(conn, params) do
    case AccountShowValidator.validate(params) do
      {:ok, validated_params} ->
        get_account_and_render(conn, validated_params)

      {:error, _} ->
        render_validation_error(conn)
    end
  end

  defp create_account(conn, %{"numero_conta" => account_number, "saldo" => balance}) do
    new_params = %{account_number: account_number, balance: balance}

    case Accounts.create_account(new_params) do
      {:ok, account} -> render_created(conn, account)
      {:error, _} -> handle_generic_error(conn)
    end
  end

  defp get_account_and_render(conn, %{"numero_conta" => account_number}) do
    case Accounts.get_account_by_number(account_number) do
      {:ok, account} -> render_ok(conn, account)
      {:error, :account_not_found} -> render_not_found(conn)
    end
  end

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
    |> json(%{error: "Conta não encontrada."})
  end

  defp render_validation_error(conn) do
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
