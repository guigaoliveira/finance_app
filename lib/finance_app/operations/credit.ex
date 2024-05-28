defmodule FinanceApp.Operations.Credit do
  @moduledoc """
  Module for processing credit operations.
  """
  alias FinanceApp.Operations
  alias FinanceApp.Operations.Operation
  alias FinanceApp.Utils

  @credit_tax Application.compile_env(:finance_app, :credit_tax)
  @company_account_number Application.compile_env(:finance_app, :company_account_number)

  @spec process(map()) :: {:ok, struct()} | {:error, term()}
  def process(%{
        customer_account_number: customer_account_number,
        amount: amount
      }) do
    updated_attrs = %Operation{
      to_account_number: customer_account_number,
      from_account_number: @company_account_number,
      transaction_type: :credit_card,
      amount: Utils.apply_tax(amount, @credit_tax)
    }

    with {:ok, %{to_account: to_account}} <- Operations.process_operation(updated_attrs) do
      {:ok, to_account}
    end
  end
end
