defmodule FinanceApp.Operations.Operation do
  @moduledoc """
  Structure representing a financial operation.
  """

  defstruct [:to_account_number, :from_account_number, :transaction_type, :amount]

  @type t :: %__MODULE__{
          to_account_number: integer(),
          from_account_number: integer(),
          transaction_type: atom(),
          amount: Decimal.t()
        }
end
