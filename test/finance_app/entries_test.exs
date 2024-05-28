defmodule FinanceApp.EntriesTest do
  use FinanceApp.DataCase, async: true

  alias FinanceApp.Entries
  alias FinanceApp.Entries.Entry

  import FinanceApp.Factory

  describe "create_entry/1" do
    test "should create a new entry" do
      transaction = insert(:transaction)
      account = insert(:account)

      attrs = %{
        direction: :debit,
        amount: 100.00,
        transaction_id: transaction.id,
        account_id: account.id
      }

      {:ok, entry} = Entries.create_entry(attrs)

      assert %Entry{} = entry
      assert entry.amount == Decimal.new("100.0")
      assert entry.direction == :debit
      assert entry.transaction_id == transaction.id
      assert entry.account_id == account.id
    end
  end
end
