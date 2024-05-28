defmodule FinanceApp.TransactionFactory do
  @moduledoc """
  Transaction Factory
  """
  alias FinanceApp.Transactions.Transaction

  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %Transaction{
          type: :pix
        }
      end
    end
  end
end
