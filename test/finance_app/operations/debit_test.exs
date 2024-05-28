defmodule FinanceApp.Operations.DebitTest do
  use FinanceApp.DataCase, async: true

  alias FinanceApp.Operations.Debit
  alias FinanceApp.Accounts.Account
  alias FinanceApp.Utils

  import FinanceApp.Factory

  @debit_tax Application.compile_env(:finance_app, :debit_tax)

  describe "process/1" do
    setup do
      to_account_balance = 200

      to_account =
        insert(:account, %{
          account_number: 1,
          balance: Decimal.new(to_account_balance)
        })

      %{to_account: to_account}
    end

    test "should process a successful operation", %{to_account: to_account} do
      from_account_number = 2
      from_account_balance = 100
      amount = 50

      insert(:account, %{
        account_number: from_account_number,
        balance: Decimal.new(from_account_balance)
      })

      operation = %{
        customer_account_number: from_account_number,
        amount: Decimal.new(amount)
      }

      assert {:ok, from_account_updated} = Debit.process(operation)

      assert to_account_updated = Repo.get(Account, to_account.id)

      amount_with_tax = Utils.apply_tax(amount, @debit_tax)

      expected_to_account_balance =
        Decimal.add(to_account.balance, amount_with_tax)

      expected_from_account_balance =
        Decimal.sub(from_account_balance, amount_with_tax)

      assert Decimal.equal?(to_account_updated.balance, expected_to_account_balance)
      assert Decimal.equal?(from_account_updated.balance, expected_from_account_balance)
    end

    test "should handle a failed operation", %{to_account: to_account} do
      from_account_number = 2
      amount = 50

      operation = %{
        customer_account_number: from_account_number,
        amount: Decimal.new(amount)
      }

      assert {:error, _} = Debit.process(operation)

      to_account_not_updated = Repo.get(Account, to_account.id)
      assert Decimal.equal?(to_account.balance, to_account_not_updated.balance)
    end
  end
end
