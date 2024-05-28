defmodule MyApp.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create_query =
      "CREATE TYPE transaction_type AS ENUM ('pix', 'debit_card', 'credit_card')"

    drop_query = "DROP TYPE transaction_type"
    execute(create_query, drop_query)

    create_query =
      "CREATE TYPE transaction_status AS ENUM ('posted', 'pending', 'archived')"

    drop_query = "DROP TYPE transaction_status"
    execute(create_query, drop_query)

    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false

      add :status, :transaction_type
      add :type, :transaction_type

      timestamps()
    end
  end
end
