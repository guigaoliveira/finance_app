defmodule FinanceApp.Operations.Pix do
  @moduledoc """
  Module for processing pix operations.
  """
  alias FinanceApp.Operations
  alias FinanceApp.Operations.Operation

  @company_account_number Application.compile_env(:finance_app, :company_account_number)

  @spec process(map()) :: {:ok, struct()} | {:error, term()}
  def process(%{
        customer_account_number: customer_account_number,
        amount: amount
      }) do
    updated_attrs = %Operation{
      to_account_number: @company_account_number,
      from_account_number: customer_account_number,
      transaction_type: :pix,
      amount: amount
    }

    with {:ok, %{from_account: from_account}} <- Operations.process_operation(updated_attrs) do
      {:ok, from_account}
    end
  end
end
