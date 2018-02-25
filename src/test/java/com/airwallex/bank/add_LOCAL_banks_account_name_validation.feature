@local
Feature: Adding LOCAL bank details
  As a API user of the AirWallex
  I should be able to use LOCAL payment methods
  So that I can transact with local banks.

  Background:
    # Server URL
    * url baseUrl
    # Endpoint /bank
    Given path 'bank'

    # Define responses as variables to substitute in Scenario Outline Examples
    * def account_details_saved_success = {"success":"Bank details saved"}
    * def account_name_required_error = {"error":"'account_name' is required"}
    * def account_name_length_error = {"error":"Length of account_name should be between 2 and 10"}

  @local @account_name
  Scenario Outline: Payment method LOCAL: Verify account_name for each country
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: #(<country>),
    bsb: "123456",
    account_name: #(<account_name>),
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @us @valid
    Examples: Valid account names are 2-10 characters long
      | country | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "US"    | "  "         | 200                  | account_details_saved_success |
      | "US"    | "12"         | 200                  | account_details_saved_success |
      | "US"    | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "US"    | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "US"    | "ABCDEFG AB" | 200                  | account_details_saved_success |
     # length 10, special characters / Non English characters
      | "US"    | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "US"    | "a<u>?&rega" | 200                  | account_details_saved_success |

  @au @valid
    Examples: Valid account names are 2-10 characters long
      | country | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "AU"    | "  "         | 200                  | account_details_saved_success |
      | "AU"    | "12"         | 200                  | account_details_saved_success |
      | "AU"    | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "AU"    | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "AU"    | "ABCDEFG AB" | 200                  | account_details_saved_success |
     # length 10, special characters / Non English characters
      | "AU"    | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "AU"    | "a<u>?&rega" | 200                  | account_details_saved_success |

  @cn @valid
    Examples: Valid account names are 2-10 characters long
      | country | account_name | expected_http_status | expected_response             |
    # 2 characters
      | "CN"    | "  "         | 200                  | account_details_saved_success |
      | "CN"    | "12"         | 200                  | account_details_saved_success |
      | "CN"    | ".."         | 200                  | account_details_saved_success |
    # boundary 9 and 10 characters
      | "CN"    | "ABCDEFG A"  | 200                  | account_details_saved_success |
      | "CN"    | "ABCDEFG AB" | 200                  | account_details_saved_success |
    # length 10, special characters / Non English characters
      | "CN"    | "ñ語中$ñ語中$ñ語" | 200                  | account_details_saved_success |
      | "CN"    | "a<u>?&rega" | 200                  | account_details_saved_success |


  @us @invalid
    Examples: Invalid account names outside 2-10 range
      | country | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | "US"    | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | "US"    | " "                                        | 400                  | account_name_length_error   |
      | "US"    | "."                                        | 400                  | account_name_length_error   |
      | "US"    | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "US"    | "13 Characters"                            | 400                  | account_name_length_error   |
      | "US"    | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "US"    | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
    # special characters / kill string / Non English characters
      | "US"    | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"          | 400                  | account_name_length_error   |
      | "US"    | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |



  @au @invalid
    Examples: Invalid account names outside 2-10 range
      | country | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | "AU"    | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | "AU"    | " "                                        | 400                  | account_name_length_error   |
      | "AU"    | "."                                        | 400                  | account_name_length_error   |
      | "AU"    | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "AU"    | "13 Characters"                            | 400                  | account_name_length_error   |
      | "AU"    | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "AU"    | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
     # special characters / kill string / Non English characters
      | "AU"    | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"          | 400                  | account_name_length_error   |
      | "AU"    | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |


  @cn @invalid
    Examples: Invalid account names outside 2-10 range
      | country | account_name                               | expected_http_status | expected_response           |
    # Empty account name
      | "CN"    | ""                                         | 400                  | account_name_required_error |
    # account names 1 character long that being space/special characters
      | "CN"    | " "                                        | 400                  | account_name_length_error   |
      | "CN"    | "."                                        | 400                  | account_name_length_error   |
      | "CN"    | "$"                                        | 400                  | account_name_length_error   |
    # account names more than 10 characters and special characters
      | "CN"    | "13 Characters"                            | 400                  | account_name_length_error   |
      | "CN"    | "ihiuhegidfkhdksdfh427589734894"           | 400                  | account_name_length_error   |
      | "CN"    | "ihiuhegidfkh!~#$%^&*()_+{}h427589734894"  | 400                  | account_name_length_error   |
      # special characters / kill string / Non English characters
      | "CN"    | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"         | 400                  | account_name_length_error   |
      | "CN"    | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}" | 400                  | account_name_length_error   |

  @bug6 @ignore
    Examples: Numeric account_name like `123456789` should NOT be saved successfully. Account name is always a string.
      | account_name | expected_http_status | expected_response           |
      #  numeric (not STRING) 9 characters long
      | 057051809    | 400                  | account_name_required_error |
