defmodule FinanceAppWeb.Validators.AccountShowValidator do
  @moduledoc """
  Account Validator
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :numero_conta, :integer
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:numero_conta])
    |> validate_required([:numero_conta])
    |> validate_number(:numero_conta, greater_than: 0, message: "must be a positive integer")
  end

  @spec validate(map()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  def validate(params) do
    case changeset(params) do
      %Ecto.Changeset{valid?: true} -> {:ok, params}
      %Ecto.Changeset{} = changeset -> {:error, changeset}
    end
  end
end
