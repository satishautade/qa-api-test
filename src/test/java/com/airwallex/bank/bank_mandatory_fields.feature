Feature:
  As a API user of the AirWallex
  My POST should only work when I provide all the mandatory details
  And I should get informative error messages, so that can correct my request
  So that I can have it ready for processing transactions.


  Background:
    # Server URL
    * url baseUrl
    # Endpoint /bank
    Given path 'bank'

  Scenario: Empty request body
    And request
    """
    {}
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
    error: "'payment_method' field required, the value should be either 'LOCAL' or 'SWIFT'"

    }
    """

  Scenario: Provide payment_method as LOCAL
    And request
    """
    {
    payment_method: "LOCAL"

    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
    error:"'bank_country_code' is required, and should be one of 'US', 'AU', or 'CN'"

    }
    """

  Scenario: Provide bank_country_code as US
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "US"

    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
    error:"'account_name' is required"

    }
    """

  Scenario: Provide account_name
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "US",
    account_name: "Satish A"

    }
    """
    When method POST
    Then status 400
    And match response ==
    """
    {
    error:"'account_number' is required"

    }
    """

  Scenario: Provide account_number
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "US",
    account_name: "Satish A",
    account_number: "057051809810"

    }
    """
    When method POST
    Then status 200
    And match response ==
    """
    {
    success:"Bank details saved"

    }
    """

  Scenario: Payment Method SWIFT : Provide account_name
    And request
    """
    {
    payment_method: "SWIFT",
    bank_country_code: "US",
    account_name: "Satish A",
    swift_code: "ICBKUSBJ",
    account_number: "057051809810"

    }
    """
    When method POST
    Then status 200
    And match response ==
    """
    {
    success:"Bank details saved"

    }
    """