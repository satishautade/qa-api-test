@swift
Feature: Adding overseas bank details - SWIFT
  As a API user of the AirWallex
  I should be able to use SWIFT payment methods
  So that I can transact with overseas banks.

  Background:
    # Server URL
    * url baseUrl
    # Endpoint /bank
    Given path 'bank'

    # Define responses as variables to substitute in Scenario Outline Examples
    * def account_details_saved_success = {"success":"Bank details saved"}
    * def account_name_required_error = {"error":"'account_name' is required"}
    * def account_name_length_error = {"error":"Length of account_name should be between 2 and 10"}

  @us @account_name
  Scenario Outline: Payment method LOCAL: Verify account_name for country US
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: "ICBKUSBJ",
    bank_country_code: "US",
    account_name: #(<account_name>),
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: Valid account names are 2-10 characters long
      | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "  "         | 200                  | account_details_saved_success |
      | "12"         | 200                  | account_details_saved_success |
      | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "ABCDEFG AB" | 200                  | account_details_saved_success |
     # length 10, special characters / Non English characters
      | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "a<u>?&rega" | 200                  | account_details_saved_success |



  @us @invalid
    Examples: Invalid account names outside 2-10 range
      | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | " "                                        | 400                  | account_name_length_error   |
      | "."                                        | 400                  | account_name_length_error   |
      | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "13 Characters"                            | 400                  | account_name_length_error   |
      | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
     # special characters / kill string / Non English characters
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                 | 400                  | account_name_length_error   |
      | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |


  @au @account_name
  Scenario Outline: Payment method LOCAL: Verify account_name for country AU
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: "ICBKAUBJ",
    bank_country_code: "AU",
    bsb: "123456",
    account_name: #(<account_name>),
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: Valid account names are 2-10 characters long
      | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "  "         | 200                  | account_details_saved_success |
      | "12"         | 200                  | account_details_saved_success |
      | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "ABCDEFG AB" | 200                  | account_details_saved_success |
     # length 10, special characters / Non English characters
      | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "a<u>?&rega" | 200                  | account_details_saved_success |


  @invalid
    Examples: Invalid account names outside 2-10 range
      | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | " "                                        | 400                  | account_name_length_error   |
      | "."                                        | 400                  | account_name_length_error   |
      | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "13 Characters"                            | 400                  | account_name_length_error   |
      | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
    # special characters / kill string / Non English characters
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                 | 400                  | account_name_length_error   |
      | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |


  @cn @account_name
  Scenario Outline: Payment method LOCAL: Verify account_name for country CN
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: "ICBKCNBJ",
    bank_country_code: "CN",
    account_name: #(<account_name>),
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: Valid account names are 2-10 characters long
      | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "  "         | 200                  | account_details_saved_success |
      | "12"         | 200                  | account_details_saved_success |
      | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "ABCDEFG AB" | 200                  | account_details_saved_success |
      # length 10, special characters / Non English characters
      | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "a<u>?&rega" | 200                  | account_details_saved_success |

  @invalid
    Examples: Invalid account names outside 2-10 range
      | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | " "                                        | 400                  | account_name_length_error   |
      | "."                                        | 400                  | account_name_length_error   |
      | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "13 Characters"                            | 400                  | account_name_length_error   |
      | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
      # special characters / kill string / Non English characters
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                 | 400                  | account_name_length_error   |
      | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |

  @bug6 @ignore
    Examples: Numeric account_name like `123456789` should NOT be saved successfully. Account name is always a string.
      | account_name | expected_http_status | expected_response           |
      #  numeric (not STRING) 9 characters long
      | 057051809    | 400                  | account_name_required_error |

