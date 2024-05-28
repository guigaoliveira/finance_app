defmodule FinanceAppWeb.AccountViewTest do
  use FinanceAppWeb.ConnCase, async: true
  alias FinanceAppWeb.AccountView

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

      assert AccountView.render("show.json", %{account: account}) == expected_json
    end
  end
end
