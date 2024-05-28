defmodule FinanceApp.Accounts do
  @moduledoc """
  Module for managing financial accounts.
  """

  import Ecto.Query
  alias FinanceApp.Repo
  alias FinanceApp.Accounts.Account

  @type ecto_return :: {:ok, Account.t()} | {:error, Ecto.Changeset.t()}
  @spec create_account(map()) :: ecto_return
  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_account(Account.t(), map()) :: ecto_return
  def update_account(account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @spec get_account_by_number(String.t(), keyword()) ::
          {:ok, Account.t()} | {:error, :account_not_found}
  def get_account_by_number(account_number, opts \\ []) do
    lock_for_update = Keyword.get(opts, :lock_for_update, false)

    query =
      Account
      |> filter_by_account_number(account_number)
      |> apply_lock?(lock_for_update)
      |> Repo.one()

    case query do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp filter_by_account_number(query, account_number) do
    where(query, [a], a.account_number == ^account_number)
  end

  defp apply_lock?(query, true), do: lock(query, "FOR UPDATE NOWAIT")
  defp apply_lock?(query, false), do: query
end
