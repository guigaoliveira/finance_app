defmodule FinanceAppWeb.OperationController do
  use FinanceAppWeb, :controller

  alias FinanceApp.Operations.Processor
  alias FinanceAppWeb.OperationView
  alias FinanceAppWeb.Validators.OperationCreateValidator

  @spec create(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def create(conn, params) do
    case OperationCreateValidator.validate(params) do
      {:ok, _} ->
        %{
          "numero_conta" => account_number,
          "valor" => amount,
          "forma_pagamento" => transaction_type
        } = params

        new_params = %{
          customer_account_number: account_number,
          amount: Decimal.new(to_string(amount)),
          transaction_type: transaction_type
        }

        new_params
        |> Processor.process_operation()
        |> render_create_result(conn)

      {:error, _} ->
        render_create_result({:error, :validation_error}, conn)
    end
  end

  defp render_create_result({:ok, account}, conn), do: render_created(conn, account)
  defp render_create_result({:error, :account_not_found}, conn), do: render_not_found(conn)
  defp render_create_result({:error, :validation_error}, conn), do: handle_validation_error(conn)
  defp render_create_result({:error, _}, conn), do: handle_generic_error(conn)

  defp render_created(conn, account) do
    conn
    |> put_status(:created)
    |> put_view(OperationView)
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
