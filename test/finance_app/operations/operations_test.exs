defmodule FinanceApp.OperationsTest do
  use FinanceApp.DataCase, async: true

  alias FinanceApp.Operations

  import FinanceApp.Factory

  describe "process_operation/1" do
    test "should process a successful operation" do
      to_account_number = 1
      from_account_number = 2
      to_account_balance = 100
      from_account_balance = 200
      amount = 50

      insert(:account, %{
        account_number: to_account_number,
        balance: Decimal.new(to_account_balance)
      })

      insert(:account, %{
        account_number: from_account_number,
        balance: Decimal.new(from_account_balance)
      })

      operation = %Operations.Operation{
        to_account_number: to_account_number,
        from_account_number: from_account_number,
        transaction_type: :debit_card,
        amount: Decimal.new(amount)
      }

      assert {:ok,
              %{
                to_account: to_account_updated,
                from_account: from_account_updated
              }} = Operations.process_operation(operation)

      assert Decimal.equal?(
               to_account_updated.balance,
               Decimal.new(to_account_balance + amount)
             )

      assert Decimal.equal?(
               from_account_updated.balance,
               Decimal.new(from_account_balance - amount)
             )
    end

    test "should handle a failed operation" do
      to_account_balance = 100
      to_account_number = 1
      from_account_balance = 100
      from_account_number = 2
      amount = 50

      to_account =
        insert(:account, %{
          account_number: to_account_number,
          balance: Decimal.new(to_account_balance)
        })

      from_account =
        insert(:account, %{
          account_number: from_account_number,
          balance: Decimal.new(from_account_balance)
        })

      operation = %Operations.Operation{
        to_account_number: to_account_number,
        # This account doesn't exist
        from_account_number: "000000000000",
        transaction_type: :debit_card,
        amount: Decimal.new(amount)
      }

      assert {:error, _} = Operations.process_operation(operation)

      assert Decimal.equal?(to_account.balance, Decimal.new(to_account_balance))
      assert Decimal.equal?(from_account.balance, Decimal.new(from_account_balance))
    end

    test "should return insufficient funds error" do
      to_account_balance = 100
      to_account_number = 1
      from_account_balance = 100
      from_account_number = 2
      amount = 100

      to_account =
        insert(:account, %{
          account_number: to_account_number,
          balance: Decimal.new(to_account_balance)
        })

      from_account =
        insert(:account, %{
          account_number: from_account_number,
          balance: Decimal.new(from_account_balance)
        })

      operation = %Operations.Operation{
        to_account_number: to_account_number,
        from_account_number: from_account_number,
        transaction_type: :debit_card,
        amount: Decimal.new(amount + 10_000)
      }

      assert {:error, :insufficient_funds} = Operations.process_operation(operation)

      assert Decimal.equal?(to_account.balance, Decimal.new(to_account_balance))
      assert Decimal.equal?(from_account.balance, Decimal.new(from_account_balance))
    end

    test "should return account not found error" do
      from_account_balance = 100
      from_account_number = 2
      amount = 100

      from_account =
        insert(:account, %{
          account_number: from_account_number,
          balance: Decimal.new(from_account_balance)
        })

      operation = %Operations.Operation{
        to_account_number: 0,
        from_account_number: from_account_number,
        transaction_type: :debit_card,
        amount: Decimal.new(amount + 10_000)
      }

      assert {:error, :account_not_found} = Operations.process_operation(operation)

      assert Decimal.equal?(from_account.balance, Decimal.new(from_account_balance))
    end
  end
end
