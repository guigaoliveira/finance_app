defmodule FinanceApp.AccountFactory do
  @moduledoc """
  Account Factory
  """
  alias FinanceApp.Accounts.Account

  defmacro __using__(_opts) do
    quote do
      def account_factory do
        %Account{
          account_number: :rand.uniform(5001),
          balance: 0
        }
      end
    end
  end
end
