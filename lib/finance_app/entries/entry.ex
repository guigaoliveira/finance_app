defmodule FinanceApp.Entries.Entry do
  @moduledoc """
  Module for representing financial entries.
  """
  use FinanceApp.Schema

  alias __MODULE__

  alias FinanceApp.Transactions.Transaction
  alias FinanceApp.Accounts.Account

  import Ecto.Changeset

  @type direction :: :debit | :credit
  @type status :: :posted | :pending | :archived

  @type t :: %Entry{
          id: String.t(),
          direction: direction,
          status: status,
          amount: Decimal.t(),
          transaction_id: String.t(),
          account_id: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "entries" do
    field :direction, Ecto.Enum, values: [:debit, :credit]
    field :status, Ecto.Enum, values: [:posted, :pending, :archived]
    field :amount, :decimal

    belongs_to :transaction, Transaction
    belongs_to :account, Account

    timestamps()
  end

  def changeset(%Entry{} = entry, attrs) when is_map(attrs) do
    entry
    |> cast(attrs, [:direction, :amount, :transaction_id, :account_id])
    |> validate_required([:direction, :amount, :transaction_id, :account_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end
