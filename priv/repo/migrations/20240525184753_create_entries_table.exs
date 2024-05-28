defmodule FinanceApp.Repo.Migrations.CreateEntriesTable do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE entries_status AS ENUM ('posted', 'pending', 'archived')"

    drop_query = "DROP TYPE entries_status"
    execute(create_query, drop_query)

    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :direction, :string
      add :amount, :decimal
      add :status, :entries_status
      add :transaction_id, references(:transactions, type: :uuid, on_delete: :delete_all)
      add :account_id, references(:accounts, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:entries, [:transaction_id])
    create index(:entries, [:account_id])
  end
end
