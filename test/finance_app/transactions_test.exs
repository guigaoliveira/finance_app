defmodule FinanceApp.TransactionsTest do
  use FinanceApp.DataCase, async: true
  alias FinanceApp.Transactions
  alias FinanceApp.Transactions.Transaction

  describe "create_transaction/1" do
    test "creates a transaction with valid attributes" do
      attrs = %{type: :debit_card}
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(attrs)
      assert transaction.type == :debit_card
    end

    test "fails to create a transaction with invalid attributes" do
      attrs = %{}
      assert {:error, changeset} = Transactions.create_transaction(attrs)
      assert %{type: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
