defmodule FinanceApp.Factory do
  @moduledoc """
  Factories
  """
  use ExMachina.Ecto, repo: FinanceApp.Repo
  use FinanceApp.AccountFactory
  use FinanceApp.TransactionFactory
end
