defmodule FinanceAppWeb.Validators.AccountCreateValidator do
  @moduledoc """
  Account Validator
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :numero_conta, :integer
    field :saldo, :decimal
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:numero_conta, :saldo])
    |> validate_required([:numero_conta, :saldo])
    |> validate_number(:numero_conta, greater_than: 0, message: "must be a positive integer")
    |> validate_number(:saldo,
      greater_than_or_equal_to: 0,
      message: "must be a non-negative number"
    )
  end

  @spec validate(map()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  def validate(params) do
    case changeset(params) do
      %Ecto.Changeset{valid?: true} -> {:ok, params}
      %Ecto.Changeset{} = changeset -> {:error, changeset}
    end
  end
end
