defmodule FinanceApp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :account_number, :integer, null: false
      add :balance, :decimal, null: false

      timestamps()
    end

    create unique_index(:accounts, [:account_number])
  end
end
