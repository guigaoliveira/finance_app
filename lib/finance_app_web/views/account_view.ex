defmodule FinanceAppWeb.AccountView do
  def render("show.json", %{account: account}) do
    %{
      numero_conta: account.account_number,
      saldo: Decimal.to_float(account.balance)
    }
  end
end
