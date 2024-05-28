defmodule FinanceApp.Accounts.AccountsTest do
  use FinanceApp.DataCase, async: true
  alias FinanceApp.Accounts.Account
  alias FinanceApp.Accounts

  describe "create_account/1" do
    test "should create account" do
      account_params = %{balance: 100.00, account_number: 1}
      {:ok, account} = Accounts.create_account(account_params)
      assert %Account{} = account
      assert account.balance == Decimal.new("100.0")
    end

    test "should not create account with negative balance" do
      assert {:error, changeset} = Accounts.create_account(%{balance: -50.00, account_number: 1})

      assert [
               balance:
                 {"must be greater than or equal to %{number}",
                  [validation: :number, kind: :greater_than_or_equal_to, number: Decimal.new("0")]}
             ] == changeset.errors
    end
  end
end
