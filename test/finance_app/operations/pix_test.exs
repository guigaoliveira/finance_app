defmodule FinanceApp.Operations.PixTest do
  use FinanceApp.DataCase, async: true

  alias FinanceApp.Operations.Pix
  alias FinanceApp.Accounts.Account

  import FinanceApp.Factory

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

      assert {:ok, from_account_updated} = Pix.process(operation)

      assert to_account_updated = Repo.get(Account, to_account.id)

      assert Decimal.equal?(
               to_account_updated.balance,
               Decimal.add(to_account.balance, Decimal.new(amount))
             )

      assert Decimal.equal?(
               from_account_updated.balance,
               Decimal.sub(from_account_balance, Decimal.new(amount))
             )
    end

    test "should handle a failed operation", %{to_account: to_account} do
      from_account_number = 2
      amount = 50

      operation = %{
        customer_account_number: from_account_number,
        amount: Decimal.new(amount)
      }

      assert {:error, _} = Pix.process(operation)

      to_account_not_updated = Repo.get(Account, to_account.id)
      assert Decimal.equal?(to_account.balance, to_account_not_updated.balance)
    end
  end
end
