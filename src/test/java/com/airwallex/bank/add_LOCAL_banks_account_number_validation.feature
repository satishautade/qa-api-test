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
    * def account_number_required_error = {"error":"'account_number' is required"}
    * def invalid_account_number_error = {"error":"Length of account_number should be between 7 and 11 when bank_country_code is 'US'"}
    * def account_details_saved_success = {"success": "Bank details saved"}


  @us @local @account_number
  Scenario Outline: Payment method LOCAL: Verify account_number for US
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "US",
    account_name: "Satish A",
    account_number: #(<account_no>)

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: Valid account numbers for US are 1-17 length (Needs to be confirmed)
      | account_no          | expected_http_status | expected_response             |
      # length 1 any character/whitespace or special
      | " "                 | 200                  | account_details_saved_success |
      | "1"                 | 200                  | account_details_saved_success |
      | "."                 | 200                  | account_details_saved_success |
      | "%"                 | 200                  | account_details_saved_success |
      # length 2 or more upto 17 characters
      | "JN"                | 200                  | account_details_saved_success |
      | "   "               | 200                  | account_details_saved_success |
      | "$% &"              | 200                  | account_details_saved_success |
      #boundary 16 and 17
      | "ummCharacters 16"  | 200                  | account_details_saved_success |
      | "ummmCharacters 17" | 200                  | account_details_saved_success |
      # valid length of special characters / kill string / Non English characters
      | "';[;]!@#$%^&*()_+" | 200                  | account_details_saved_success |
      | "ñ語中${{=\">'>%AE"   | 200                  | account_details_saved_success |

  @bug1 @ignore
    Examples: Providing aba is NOT enforced for payment_method:"LOCAL" and bank_country_code: "US"
      | account_no          | expected_http_status | expected_response                                           |
      | "12345678910111212" | 400                  | {error: "'aba' is required when bank country code is 'US'"} |
    # The error message above is NOT returned by API but it's derived from similar error for AU

  @bug4 @ignore
    Examples: For US, account_number:"0" is saved successfully. It doesn't appear to be valid account_number.
      | account_no | expected_http_status | expected_response             |
      | "0"        | 400                  | account_number_required_error |

  @invalid
    Examples: For US Invalid account_number are outside 1 - 17 range
      | account_no                                                     | expected_http_status | expected_response             |
      #  account number empty or zero
      | ""                                                             | 400                  | account_number_required_error |
      # account number 18 or more characters long
      | "123456095238092099"                                           | 400                  | invalid_account_number_error  |
      | "123456095kjasgkbh98943s7897498379DSFBBUSVSL';[;][87693826796" | 400                  | invalid_account_number_error  |
      #  numeric (not STRING) 17 characters long
      | 05705180981998090                                              | 400                  | invalid_account_number_error  |
      # special characters / kill string / Non English characters
      | "a<u>?&reg;#</u>}}"                                            | 400                  | invalid_account_number_error  |
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                             | 400                  | invalid_account_number_error  |


  @au @local @account_number
  Scenario Outline: Payment method LOCAL: Verify account_number for AU
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "AU",
    bsb: "123456",
    account_name: "Satish A",
    account_number: #(<account_no>)

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>


  @valid
    Examples: For AU VALID account_number are within 6 - 9 range
      | account_no  | expected_http_status | expected_response             |
      | "123456"    | 200                  | account_details_saved_success |
      #boundary 8 and 9
      | "ABND1289"  | 200                  | account_details_saved_success |
      | "12345ABCD" | 200                  | account_details_saved_success |
      # valid length of special characters / kill string / Non English characters
      | ";'[]!@#$%" | 200                  | account_details_saved_success |
      | "ñ語中${{="   | 200                  | account_details_saved_success |

  @invalid
    Examples: For AU INVALID account_number are within 6 - 9 range
      | account_no                                                     | expected_http_status | expected_response             |
      #  account number empty or zero
      | ""                                                             | 400                  | account_number_required_error |
      # account number less than 6 characters long
      | "."                                                            | 400                  | invalid_account_number_error  |
      | "1"                                                            | 400                  | invalid_account_number_error  |
      | "12345"                                                        | 400                  | invalid_account_number_error  |
      | "@#$ ^"                                                        | 400                  | invalid_account_number_error  |
      # account number more than 9 characters long
      | "          "                                                   | 400                  | invalid_account_number_error  |
      | "1234567890"                                                   | 400                  | invalid_account_number_error  |
      | "123456789ABCDEFGHIJ"                                          | 400                  | invalid_account_number_error  |
      | "123456095kjasgkbh98943s7897498379DSFBBUSVSL';[;][87693826796" | 400                  | invalid_account_number_error  |
      #  numeric (not STRING) 9 characters long
      | 057051809                                                      | 400                  | invalid_account_number_error  |
      # special characters / kill string / Non English characters
      | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}"                     | 400                  | invalid_account_number_error  |
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                                     | 400                  | invalid_account_number_error  |


  @bug5 @ignore
    Examples: For AU and CN, account_number:"0" returns invalid_account_number_error instead of account_number_required_error
      | account_no | expected_http_status | expected_response             |
      | "0"        | 400                  | account_number_required_error |


  @cn @local @account_number
  Scenario Outline: Payment method LOCAL: Verify account_number for CN
    And request
    """
    {
    payment_method: "LOCAL",
    bank_country_code: "CN",
    account_name: "Satish A",
    account_number: #(<account_no>)

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>


  @valid
    Examples: For CN VALID account_number are within 8 - 20 range
      | account_no  | expected_http_status | expected_response             |
      | "12345678"  | 200                  | account_details_saved_success |
      | "123456789" | 200                  | account_details_saved_success |
      # valid length of special characters / kill string / Non English characters
      | ";'[]!@#$%" | 200                  | account_details_saved_success |
      | "ñ語中${{="   | 200                  | account_details_saved_success |

  @bug2 @ignore
    Examples: For bank country CN, maximum length of account_number is only 9 characters (should be 20 as per requirements)
      | account_no             | expected_http_status | expected_response             |
      # 10 characters or more long account_number fails
      | "10Charfail"           | 200                  | account_details_saved_success |
      #boundary length 19 and 20
      | "ABNDNHuwiuy-Chars19"  | 200                  | account_details_saved_success |
      | "ABNDNHuwiuy1-Chars20" | 200                  | account_details_saved_success |

  @invalid
    Examples: For CN INVALID account_number are outside 8 - 20 range
      | account_no                                                     | expected_http_status | expected_response             |
      #  account number empty or zero
      | ""                                                             | 400                  | account_number_required_error |
      # account number less than 8 characters long
      | "."                                                            | 400                  | invalid_account_number_error  |
      | " "                                                            | 400                  | invalid_account_number_error  |
      | "1"                                                            | 400                  | invalid_account_number_error  |
      | "12345"                                                        | 400                  | invalid_account_number_error  |
      # account number more than 20 characters long
      | "                     "                                        | 400                  | invalid_account_number_error  |
      | "123456789ABCDEFGHIJafloiu"                                    | 400                  | invalid_account_number_error  |
      | "123456095kjasgkbh98943s7897498379DSFBBUSVSL';[;][87693826796" | 400                  | invalid_account_number_error  |
      #  numeric (not STRING) 9 characters long
      | 057051809                                                      | 400                  | invalid_account_number_error  |
      # special characters / kill string / Non English characters
      | "a<u>?&rega<u>?&reg;#ñ語中${{=">'>%AE</u>}}"                    | 400                  | invalid_account_number_error  |
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"                             | 400                  | invalid_account_number_error  |


  @bug5 @ignore
    Examples: For AU and CN, account_number:"0" returns invalid_account_number_error instead of account_number_required_error
      | account_no | expected_http_status | expected_response             |
      | "0"        | 400                  | account_number_required_error |

  @bug3 @ignore
    Examples: For bank_country_code:"CN", minimum length of account_number is only 7 characters (should be 8 as per requirements)
      | account_no | expected_http_status | expected_response            |
      | "1234567"  | 400                  | invalid_account_number_error |