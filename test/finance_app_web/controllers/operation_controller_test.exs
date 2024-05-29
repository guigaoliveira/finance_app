defmodule FinanceAppWeb.OperationsControllerTest do
  use FinanceAppWeb.ConnCase, async: true

  import FinanceApp.Factory

  describe "POST /transacao" do
    test "should create pix transaction", %{conn: conn} do
      from_account_number = 2
      from_account_balance = 1000
      amount = 10
      transaction_type = "P"

      operation_params = %{
        "numero_conta" => from_account_number,
        "valor" => amount,
        "forma_pagamento" => transaction_type
      }

      insert(:account, %{account_number: 1, balance: 100_000_000})
      insert(:account, %{account_number: from_account_number, balance: from_account_balance})

      conn = post(conn, "/transacao", operation_params)

      assert response = json_response(conn, 201)
      assert response["numero_conta"] == from_account_number
      assert response["saldo"] < from_account_balance
    end

    test "should create debit transaction", %{conn: conn} do
      from_account_number = 2
      from_account_balance = 1000
      amount = 10
      transaction_type = "D"

      operation_params = %{
        "numero_conta" => from_account_number,
        "valor" => amount,
        "forma_pagamento" => transaction_type
      }

      insert(:account, %{account_number: 1, balance: 100_000_000})
      insert(:account, %{account_number: from_account_number, balance: from_account_balance})

      conn = post(conn, "/transacao", operation_params)

      assert response = json_response(conn, 201)
      assert response["numero_conta"] == from_account_number
      assert response["saldo"] < from_account_balance
    end

    test "should create credit transaction", %{conn: conn} do
      to_account_number = 2
      to_account_balance = 1000
      amount = 10
      transaction_type = "C"

      operation_params = %{
        "numero_conta" => to_account_number,
        "valor" => amount,
        "forma_pagamento" => transaction_type
      }

      insert(:account, %{account_number: 1, balance: 100_000_000})
      insert(:account, %{account_number: to_account_number, balance: to_account_balance})

      conn = post(conn, "/transacao", operation_params)

      assert response = json_response(conn, 201)
      assert response["numero_conta"] == to_account_number
      assert response["saldo"] > to_account_balance
    end

    test "should return a not found error", %{conn: conn} do
      to_account_number = 2
      amount = 10
      transaction_type = "C"

      operation_params = %{
        "numero_conta" => to_account_number,
        "valor" => amount,
        "forma_pagamento" => transaction_type
      }

      insert(:account, %{account_number: 1, balance: 100_000_000})

      conn = post(conn, "/transacao", operation_params)

      assert response = json_response(conn, 404)
      assert response["error"] == "Conta não encontrada."
    end

    test "returns validation error with invalid params", %{conn: conn} do
      invalid_params = %{saldo: "non exist"}

      conn = post(conn, "/transacao", invalid_params)

      assert response = json_response(conn, 422)

      assert response["error"] == "Dados inválidos, verifique os dados enviados."
    end

    test "returns insufficient funds error with invalid params", %{conn: conn} do
      from_account_number = 2
      from_account_balance = 1000
      amount = 10000
      transaction_type = "D"

      operation_params = %{
        "numero_conta" => from_account_number,
        "valor" => amount,
        "forma_pagamento" => transaction_type
      }

      insert(:account, %{account_number: 1, balance: 100_000_000})
      insert(:account, %{account_number: from_account_number, balance: from_account_balance})

      conn = post(conn, "/transacao", operation_params)

      assert response = json_response(conn, 422)

      assert response["error"] == "Fundos insuficientes para realizar a operação."
    end
  end
end
