defmodule FinanceApp.Operations.Processor do
  @moduledoc """
  Module for processing financial operations based on transaction type.
  """
  alias FinanceApp.Operations.{Credit, Debit, Pix}

  @spec process_operation(map()) :: {:ok, struct()} | {:error, term()}
  def process_operation(%{transaction_type: "D"} = params), do: Debit.process(params)

  def process_operation(%{transaction_type: "C"} = params), do: Credit.process(params)

  def process_operation(%{transaction_type: "P"} = params), do: Pix.process(params)
end
