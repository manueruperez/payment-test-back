# [LIVE DEMO](https://payment-test-back-a0012f8a4e67.herokuapp.com/)

# ENDPOINTS:

- /riders/payment-method (add payment source)
- /riders/request-ride (request ride)
- drivers/finish-rides (finish ride)

# Ruby Sinatra Backend API

This repository contains a backend API built with Ruby and Sinatra, designed to showcase RESTful API design using Ruby's elegant syntax and Sinatra's lightweight framework.

## Features

- RESTful API endpoints.
- PostgreSQL database integration via ElephantSQL.
- Deployment on Heroku.
- Usage of an ORM (Sequel) for database operations.
- Environment variable management with Dotenv.
- Data validation with dry-validation.
- External API interaction with HTTParty and Rest-Client.

## Prerequisites

Before you begin, ensure you have met the following requirements:
- Ruby installed on your machine (see [ruby-lang.org](https://www.ruby-lang.org/en/downloads/) for installation instructions).
- Bundler installed (`gem install bundler`).
- Access to a PostgreSQL database.

## Installation

To install the application, follow these steps:

1. Clone the repository
2. Navigate to the project directory:
3. Install the required gems:
´´´
bundle install
´´´

## Configuration

Create a `.env` file in the root directory of your project and add your environment variables:
´´´
SESSION_SECRET = c03a75d3ead346bdf441e9184bb1368cbbd7da31af187d847a067e2890e60ec13da886e1f8ec7b50f2891cc37b71789fa9f0c28d9e4e946f2e6cfd1d7b9d6760
DATABASE_URL = ***********************
PAYMENT_PUBLIC_SECRET_KEY = pub_test_7I2O6wAUmXpS0kh4IaSZOzdu2HUJrtXm
PAYMENT_PRIVATE_SECRET_KEY = prv_test_SedRXry89OGlKjjsNJNOMdFpechLTWsK
PAYMENT_API_SANDBOX = https://sandbox.wompi.co/v1
´´´

## Running the Application

To run the application locally, execute:
´´´
ruby app.rb
´´´

This will start a local server. Access the API at `http://localhost:4567`.

## Deploying to Heroku

This application is deployed on Heroku at the following URL: [https://payment-test-back-a0012f8a4e67.herokuapp.com/](https://payment-test-back-a0012f8a4e67.herokuapp.com/).

For instructions on deploying your own Sinatra application to Heroku, refer to the [Heroku Ruby documentation](https://devcenter.heroku.com/articles/getting-started-with-ruby).

## Contributing

Contributions are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the [MIT License](LICENSE.md) - see the LICENSE file for details.
