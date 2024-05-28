defmodule FinanceApp.Accounts.Account do
  @moduledoc """
  Module for representing financial account.
  """
  use FinanceApp.Schema

  import Ecto.Changeset

  alias FinanceApp.Entries.Entry

  alias __MODULE__

  @type t() :: %Account{
          id: String.t(),
          account_number: integer(),
          balance: Decimal.t(),
          entries: [%Entry{}],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "accounts" do
    field :account_number, :integer
    field :balance, :decimal

    has_many :entries, Entry

    timestamps()
  end

  def changeset(%Account{} = account, attrs) when is_map(attrs) do
    account
    |> cast(attrs, [:account_number, :balance])
    |> validate_required([:account_number, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:account_number)
  end
end
