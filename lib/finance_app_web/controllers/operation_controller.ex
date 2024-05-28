defmodule FinanceAppWeb.OperationController do
  use FinanceAppWeb, :controller

  alias FinanceApp.Operations.Processor
  alias FinanceAppWeb.OperationView
  alias FinanceAppWeb.Validators.OperationCreateValidator

  @doc """
  Create a new operation.
  """
  @spec create(conn :: Plug.Conn.t(), params :: map()) :: Plug.Conn.t()
  def create(conn, params) do
    case OperationCreateValidator.validate(params) do
      {:ok, validated_params} ->
        process_operation(conn, validated_params)

      {:error, _} ->
        render_validation_error(conn)
    end
  end

  defp process_operation(conn, params) do
    new_params = %{
      customer_account_number: params.numero_conta,
      amount: params.valor,
      transaction_type: params.forma_pagamento
    }

    case Processor.process_operation(new_params) do
      {:ok, account} -> render_created(conn, account)
      {:error, :account_not_found} -> render_not_found(conn)
      {:error, _} -> handle_generic_error(conn)
    end
  end

  defp render_created(conn, account) do
    conn
    |> put_status(:created)
    |> put_view(OperationView)
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
