defmodule FinanceApp.Operations.CreditTest do
  use FinanceApp.DataCase, async: true

  alias FinanceApp.Operations.Credit
  alias FinanceApp.Accounts.Account
  alias FinanceApp.Utils

  import FinanceApp.Factory

  @credit_tax Application.compile_env(:finance_app, :credit_tax)

  describe "process/1" do
    setup do
      to_account_balance = 200

      from_account =
        insert(:account, %{
          account_number: 1,
          balance: Decimal.new(to_account_balance)
        })

      %{from_account: from_account}
    end

    test "should process a successful operation", %{from_account: from_account} do
      to_account_number = 2
      to_account_balance = 100
      amount = 50

      insert(:account, %{
        account_number: to_account_number,
        balance: Decimal.new(to_account_balance)
      })

      operation = %{
        customer_account_number: to_account_number,
        amount: Decimal.new(amount)
      }

      assert {:ok, to_account_updated} = Credit.process(operation)

      assert from_account_updated = Repo.get(Account, from_account.id)

      amount_with_tax = Utils.apply_tax(amount, @credit_tax)

      expected_to_account_balance =
        Decimal.add(to_account_balance, amount_with_tax)

      expected_from_account_balance =
        Decimal.sub(from_account.balance, amount_with_tax)

      assert Decimal.equal?(to_account_updated.balance, expected_to_account_balance)
      assert Decimal.equal?(from_account_updated.balance, expected_from_account_balance)
    end

    test "should handle a failed operation", %{from_account: from_account} do
      to_account_number = 2
      amount = 50

      operation = %{
        customer_account_number: to_account_number,
        amount: Decimal.new(amount)
      }

      assert {:error, _} = Credit.process(operation)

      from_account_not_updated = Repo.get(Account, from_account.id)
      assert Decimal.equal?(from_account.balance, from_account_not_updated.balance)
    end
  end
end
