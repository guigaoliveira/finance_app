defmodule FinanceApp.Operations do
  @moduledoc """
  Module for processing financial operations.
  """
  alias FinanceApp.Repo
  alias FinanceApp.Accounts
  alias FinanceApp.Accounts.Account
  alias FinanceApp.Transactions
  alias FinanceApp.Entries
  alias FinanceApp.Operations.Operation

  @spec process_operation(Operation.t()) ::
          {:ok, %{to_account: Account.t(), from_account: Account.t()}} | {:error, term()}
  def process_operation(%Operation{
        to_account_number: to_account_number,
        from_account_number: from_account_number,
        transaction_type: transaction_type,
        amount: amount
      }) do
    Repo.transaction(fn ->
      with {:ok, to_account} <- get_locked_account(to_account_number),
           {:ok, from_account} <- get_locked_account(from_account_number),
           :ok <- check_balance(from_account, amount),
           {:ok, transaction} <- create_transaction(transaction_type),
           {:ok, _} <- create_entry(to_account, transaction, :debit, amount),
           {:ok, _} <- create_entry(from_account, transaction, :credit, amount),
           {:ok, to_account_updated} <- update_account_balance(to_account, amount, :add),
           {:ok, from_account_updated} <- update_account_balance(from_account, amount, :sub) do
        %{
          to_account: to_account_updated,
          from_account: from_account_updated
        }
      else
        {:error, error} ->
          Repo.rollback(error)
          error

        error ->
          Repo.rollback(error)
          error
      end
    end)
  end

  defp get_locked_account(account_number) do
    Accounts.get_account_by_number(account_number, lock_for_update: true)
  end

  defp check_balance(account, amount) do
    if Decimal.compare(account.balance, amount) != :lt do
      :ok
    else
      {:error, :insufficient_funds}
    end
  end

  defp create_transaction(transaction_type) do
    Transactions.create_transaction(%{type: transaction_type, status: :posted})
  end

  defp create_entry(account, transaction, direction, amount) do
    Entries.create_entry(%{
      account_id: account.id,
      transaction_id: transaction.id,
      direction: direction,
      amount: amount,
      status: :posted
    })
  end

  defp update_account_balance(account, amount, :add) do
    Accounts.update_account(account, %{
      balance: Decimal.add(account.balance, amount)
    })
  end

  defp update_account_balance(account, amount, :sub) do
    Accounts.update_account(account, %{
      balance: Decimal.sub(account.balance, amount)
    })
  end
end
