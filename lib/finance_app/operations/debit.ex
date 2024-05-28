defmodule FinanceApp.Operations.Debit do
  @moduledoc """
  Module for processing debit operations.
  """
  alias FinanceApp.Operations
  alias FinanceApp.Operations.Operation
  alias FinanceApp.Utils

  @debit_tax Application.compile_env(:finance_app, :debit_tax)
  @company_account_number Application.compile_env(:finance_app, :company_account_number)

  @spec process(map()) :: {:ok, struct()} | {:error, term()}
  def process(%{
        customer_account_number: customer_account_number,
        amount: amount
      }) do
    updated_attrs = %Operation{
      to_account_number: @company_account_number,
      from_account_number: customer_account_number,
      transaction_type: :debit_card,
      amount: Utils.apply_tax(amount, @debit_tax)
    }

    with {:ok, %{from_account: from_account}} <- Operations.process_operation(updated_attrs) do
      {:ok, from_account}
    end
  end
end
