defmodule FinanceApp.Transactions do
  @moduledoc """
  Module for managing financial transactions.
  """
  alias FinanceApp.Repo
  alias FinanceApp.Transactions.Transaction

  @doc """
  Creates a new transaction.
  """
  def create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
