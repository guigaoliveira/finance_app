defmodule FinanceApp.Utils do
  @moduledoc """
  Utility functions
  """
  @spec apply_tax(Decimal.t(), float()) :: Decimal.t()
  def apply_tax(amount, tax) when is_number(tax) do
    Decimal.mult(amount, Decimal.add(1, Decimal.from_float(tax)))
  end
end
