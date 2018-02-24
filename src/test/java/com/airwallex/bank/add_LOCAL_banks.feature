Feature: Adding LOCAL bank details
  As a API user of the AirWallex
  I should be able to use LOCAL payment methods
  So that I can transact with local banks.

  Background:
    # Server URL
    * url baseUrl
    # Endpoint /bank
    Given path 'bank'

  Scenario Outline: account_number length validations
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: #(<country>),
    account_name: "Satish A",
    account_number: #(<account_no>)

    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
    error: #(<expected_response>)

    }
    """

    @bug1
    Examples: For US account_number = " " should NOT pass the validation but it does.
      | country   | account_no        | expected_response                                                                    |
      | "US"      | " " | "Length of account_number should be between 7 and 11 when bank_country_code is 'US'" |