defmodule FinanceAppWeb.OperationViewTest do
  use FinanceAppWeb.ConnCase, async: true
  alias FinanceAppWeb.OperationView

  describe "render/2" do
    test "should renders account JSON" do
      account = %{
        account_number: 123,
        balance: Decimal.new(1000)
      }

      expected_json = %{
        numero_conta: 123,
        saldo: 1000
      }

      assert OperationView.render("show.json", %{account: account}) == expected_json
    end
  end
end
