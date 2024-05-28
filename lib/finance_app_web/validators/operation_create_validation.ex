defmodule FinanceAppWeb.Validators.OperationCreateValidator do
  @moduledoc """
  Module for validating parameters for operation.
  """

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :numero_conta, :integer
    field :valor, :decimal
    field :forma_pagamento, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:numero_conta, :valor, :forma_pagamento])
    |> validate_required([:numero_conta, :valor, :forma_pagamento])
    |> validate_number(:numero_conta, greater_than: 0, message: "must be a positive integer")
    |> validate_number(:valor,
      greater_than: 0,
      message: "must be a non-negative number"
    )
    |> validate_inclusion(:forma_pagamento, ["D", "P", "C"],
      message: "must be one of 'D', 'P', or 'C'"
    )
  end

  @spec validate(map()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  def validate(params) do
    case changeset(params) do
      %Ecto.Changeset{valid?: true} = changeset -> {:ok, changeset.changes}
      %Ecto.Changeset{} = changeset -> {:error, changeset}
    end
  end
end
