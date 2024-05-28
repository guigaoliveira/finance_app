defmodule FinanceApp.Transactions.Transaction do
  @moduledoc """
  Module for representing financial transactions.
  """
  use FinanceApp.Schema
  alias FinanceApp.Entries.Entry

  alias __MODULE__

  import Ecto.Changeset

  @type status :: :posted | :pending | :archived
  @type type :: :pix | :debit_card | :credit_card

  @type t :: %Transaction{
          id: String.t(),
          type: type,
          status: status,
          entries: [Entry.t()],
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "transactions" do
    field :type, Ecto.Enum, values: [:pix, :debit_card, :credit_card]
    field :status, Ecto.Enum, values: [:posted, :pending, :archived]

    has_many :entries, Entry

    timestamps()
  end

  def changeset(%Transaction{} = transaction, attrs) when is_map(attrs) do
    transaction
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
