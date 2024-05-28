defmodule FinanceApp.Entries do
  @moduledoc """
  Module for managing financial entries.
  """
  alias FinanceApp.Repo
  alias FinanceApp.Entries.Entry

  @doc """
  Creates a new entry.
  """
  def create_entry(attrs) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end
end
