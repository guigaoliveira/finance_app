# FinanceApp

FinanceApp is a banking management system built as an API, designed to facilitate banking operations through two main endpoints: "/conta" and "/transacao". The "/conta" endpoint is responsible for creating and providing information about bank accounts. On the other hand, the "/transacao" endpoint handles various financial transactions.

## Before Running

1. Ensure you have Docker Compose installed on your machine.
2. Clone the project repository from GitHub.

## Running the Project

1. Open a terminal.
2. Navigate to the root directory of the project.
3. Run the following command to start the Docker containers: `docker-compose up -d`

### Starting Phoenix Server

1. Open a new terminal window or tab.
2. Navigate to the root directory of the project.

3. Run the following command to install and setup dependencies:
   `mix setup`

4. After the setup is complete, start the Phoenix server by running:
   `mix phx.server`

### Testing Endpoints

Use an API testing tool like Postman or curl to test the endpoints.

Use the following endpoints with their respective payloads:

- POST /conta:

Send a POST request to http://localhost:4000/conta with the payload:

```json
{ "numero_conta": 234, "saldo": 180.37 }
```

- POST /transacao:

Send a POST request to http://localhost:4000/transacao with the payload:

```json
{ "forma_pagamento": "D", "numero_conta": 234, "valor": 10 }
```

- GET /conta?numero_conta=234:

Send a GET request to http://localhost:4000/conta?numero_conta=234

### Running Tests

1. To run tests, navigate to the root directory of the project in a terminal.
2. Run the following command:
   `mix test`
3. This will run all the tests in the project and display the results.

### Viewing Test Coverage

1. To view test coverage, navigate to the root directory of the project in a terminal.
2. Run the following command:
   `mix coveralls.html`
3. This will generate a coverage report that you can view in your terminal or open the HTML report located at cover/excoveralls.html in a web browser.
