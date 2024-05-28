defmodule FinanceAppWeb.AccountControllerTest do
  use FinanceAppWeb.ConnCase, async: true

  import FinanceApp.Factory

  describe "POST /conta" do
    test "creates account with valid params", %{conn: conn} do
      account_number = 1
      balance = 1000.00
      account_params = %{numero_conta: account_number, saldo: balance}

      conn = post(conn, ~p"/conta", account_params)
      assert conn.status == 201

      assert response = json_response(conn, 201)
      assert response["numero_conta"] == account_number
      assert response["saldo"] == balance
    end

    test "returns error with invalid params", %{conn: conn} do
      invalid_params = %{}

      conn = post(conn, ~p"/conta", invalid_params)

      assert conn.status == 422
    end
  end

  describe "GET /conta?numero_conta=value" do
    test "returns account by number", %{conn: conn} do
      account_number = 1
      balance = 1000.00
      insert(:account, %{account_number: account_number, balance: balance})
      conn = get(conn, ~p"/conta?numero_conta=#{account_number}")

      assert response = json_response(conn, 200)
      assert response["numero_conta"] == account_number
      assert response["saldo"] == balance
    end

    test "returns not found for non-existent account", %{conn: conn} do
      account_number = 2

      conn = get(conn, ~p"/conta?numero_conta=#{account_number}")

      assert response = json_response(conn, 404)

      assert response["error"] == "Conta não encontrada"
    end

    test "returns when account number is not number", %{conn: conn} do
      account_number = "non exist"

      conn = get(conn, ~p"/conta?numero_conta=#{account_number}")

      assert response = json_response(conn, 422)

      assert response["error"] == "Dados inválidos, verifique os dados enviados."
    end
  end
end
