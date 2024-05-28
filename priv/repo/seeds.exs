alias FinanceApp.Repo
alias FinanceApp.Accounts.Account

balance = Decimal.new("100000000000000000000000000000000000000000000")

company_account_attrs = %{
  account_number: 1,
  balance: balance
}

existing_account = Repo.get_by(Account, account_number: company_account_attrs.account_number)

if is_nil(existing_account) do
  case Repo.insert(Account.changeset(%Account{}, company_account_attrs)) do
    {:ok, _} ->
      IO.puts("Company account created successfully!")

    {:error, changeset} ->
      IO.puts("Error creating company account:")
      IO.inspect(changeset.errors)
  end
end
