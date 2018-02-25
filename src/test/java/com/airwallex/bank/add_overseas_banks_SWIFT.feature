@swift_code
Feature: Adding overseas bank details - SWIFT
  As a API user of the AirWallex
  I should be able to use SWIFT payment methods
  So that I can transact with overseas banks.

  Background:
    # Server URL
    * url baseUrl
    # Endpoint /bank
    Given path 'bank'

    * def no_swift_code_error =  {"error":"'swift_code' is required when payment method is 'SWIFT'"}
    * def swift_code_length_error = {"error":"Length of 'swift_code' should be either 8 or 11"}
    * def account_details_saved_success = {"success":"Bank details saved"}
    * def invalid_swift_code_error_for_US = {"error":"The swift code is not valid for the given bank country code: US"}
    * def invalid_swift_code_error_for_AU = {"error":"The swift code is not valid for the given bank country code: AU"}
    * def invalid_swift_code_error_for_CN = {"error":"The swift code is not valid for the given bank country code: CN"}

  Scenario Outline: No SWIFT code for each country
    And request
    """
    {
    payment_method: "SWIFT",
    bank_country_code: #(<country>),
    account_name: "Satish A",
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status 400
    And match response == <expected_response>

    Examples:
      | country | expected_response   |
      | "US"    | no_swift_code_error |
      | "AU"    | no_swift_code_error |
      | "CN"    | no_swift_code_error |


  @us @characters
  Scenario Outline: 5th and 6th character in the SWIFT code for country US
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: #(<swift_code>),
    bank_country_code: "US",
    account_name: "Satish A",
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: 8 characters long with 5 and 6th character matching country code
      | swift_code | expected_http_status | expected_response             |
      # upper case
      | "ABCDUSEF" | 200                  | account_details_saved_success |
      | "1234US78" | 200                  | account_details_saved_success |
      # special and white characters
      | "    US  " | 200                  | account_details_saved_success |
      | "****US**" | 200                  | account_details_saved_success |
      | "----US--" | 200                  | account_details_saved_success |
      | "!@#$US%^" | 200                  | account_details_saved_success |


  @valid
    Examples: 11 characters long with 5 and 6th character matching country code
      | swift_code    | expected_http_status | expected_response             |
      # upper case
      | "ABCDUSEFGHI" | 200                  | account_details_saved_success |
      | "1234US78910" | 200                  | account_details_saved_success |
      # special and white characters
      | "    US     " | 200                  | account_details_saved_success |
      | "****US*****" | 200                  | account_details_saved_success |
      | "----US-----" | 200                  | account_details_saved_success |
      | "!@#$US%^)(*" | 200                  | account_details_saved_success |


  @invalid
    Examples: Different length and 5, 6th characters not 'US'
      | swift_code                                 | expected_http_status | expected_response               |
      # 8 characters long but 5th and 6th char different than US
      | "ICBKCNBJ"                                 | 400                  | invalid_swift_code_error_for_US |
      | "ICBKUKBJ"                                 | 400                  | invalid_swift_code_error_for_US |
      # 8 characters long but lower case 'us'
      | "1234us78"                                 | 400                  | invalid_swift_code_error_for_US |
      | "abcdusef"                                 | 400                  | invalid_swift_code_error_for_US |
      # 11 characters long but lower case 'us'
      | "1234us78910"                              | 400                  | invalid_swift_code_error_for_US |
      | "abcdusefghi"                              | 400                  | invalid_swift_code_error_for_US |
      #boundary lengths 7,9,10,12 with 5,6th characters as US
      | "1234US7"                                  | 400                  | swift_code_length_error         |
      | "1234US789112"                             | 400                  | swift_code_length_error         |
      # more than 8/11 chars and special chars
      | "&reg;>'>%AE"                              | 400                  | invalid_swift_code_error_for_US |
      | "ñ語中$ñ語中ñ語中"                           | 400                  | invalid_swift_code_error_for_US |
      # more than 11 chars and special chars
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"          | 400                  | swift_code_length_error         |

      # some parsing issues in running this string. Commenting it for now.
#      | "a<u>?&rega<u>?&reg;{{=>'>%AE</u>}}" | 400                  | swift_code_length_error         |

  @bug5 @ignore
    Examples: swift_code of length 9 and 10 should NOT be saved successfully.
    As per requirements, valid swift_code is either 8 or 11 characters long.
      | swift_code   | expected_http_status | expected_response       |
      | "1234US7-9"  | 400                  | swift_code_length_error |
      | "1234US7-10" | 400                  | swift_code_length_error |


  @au @characters
  Scenario Outline: 5th and 6th character in the SWIFT code for country AU
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: #(<swift_code>),
    bank_country_code: "AU",
    bsb: "123456",
    account_name: "Satish A",
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: 8 characters long with 5 and 6th character matching country code
      | swift_code | expected_http_status | expected_response             |
      # upper case
      | "ABCDAUEF" | 200                  | account_details_saved_success |
      | "1234AU78" | 200                  | account_details_saved_success |
      # special and white characters
      | "    AU  " | 200                  | account_details_saved_success |
      | "****AU**" | 200                  | account_details_saved_success |
      | "----AU--" | 200                  | account_details_saved_success |
      | "!@#$AU%^" | 200                  | account_details_saved_success |


  @valid
    Examples: 11 characters long with 5 and 6th character matching country code
      | swift_code    | expected_http_status | expected_response             |
      # upper case
      | "ABCDAUEFGHI" | 200                  | account_details_saved_success |
      | "1234AU78910" | 200                  | account_details_saved_success |
      # special and white characters
      | "    AU     " | 200                  | account_details_saved_success |
      | "****AU*****" | 200                  | account_details_saved_success |
      | "----AU-----" | 200                  | account_details_saved_success |
      | "!@#$AU%^)(*" | 200                  | account_details_saved_success |


  @invalid
    Examples: Different length and 5, 6th characters not 'AU'
      | swift_code                                 | expected_http_status | expected_response               |
      # 8 characters long but 5th and 6th char different than AU
      | "ICBKHZBJ"                                 | 400                  | invalid_swift_code_error_for_AU |
      | "ICBKUKBJ"                                 | 400                  | invalid_swift_code_error_for_AU |
      # 8 characters long but lower case 'us'
      | "1234au78"                                 | 400                  | invalid_swift_code_error_for_AU |
      | "abcdauef"                                 | 400                  | invalid_swift_code_error_for_AU |
      # 11 characters long but lower case 'us'
      | "1234au78910"                              | 400                  | invalid_swift_code_error_for_AU |
      | "abcdauefghi"                              | 400                  | invalid_swift_code_error_for_AU |
      #boundary lengths 7,9,10,12 with 5,6th characters as AU
      | "1234AU7"                                  | 400                  | swift_code_length_error         |
      | "1234AU789112"                             | 400                  | swift_code_length_error         |
      # more than 8/11 chars and special chars
      | "&reg;>'>%AE"                              | 400                  | invalid_swift_code_error_for_AU |
      | "ñ語中$ñ語中ñ語中"                           | 400                  | invalid_swift_code_error_for_AU |
      # more than 11 chars and special chars
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"          | 400                  | swift_code_length_error         |

      # some parsing issues in running this string. Commenting it for now.
#      | "a<u>?&rega<u>?&reg;{{=>'>%AE</u>}}" | 400                  | swift_code_length_error         |


  @cn @characters
  Scenario Outline: 5th and 6th character in the SWIFT code for country CN
    And request
    """
    {
    payment_method: "SWIFT",
    swift_code: #(<swift_code>),
    bank_country_code: "CN",
    account_name: "Satish A",
    account_number: "ABCD12345"

    }
    """
    When method POST
    Then status <expected_http_status>
    And match response == <expected_response>

  @valid
    Examples: 8 characters long with 5 and 6th character matching country code
      | swift_code | expected_http_status | expected_response             |
      # upper case
      | "ABCDCNEF" | 200                  | account_details_saved_success |
      | "1234CN78" | 200                  | account_details_saved_success |
      # special and white characters
      | "    CN  " | 200                  | account_details_saved_success |
      | "****CN**" | 200                  | account_details_saved_success |
      | "----CN--" | 200                  | account_details_saved_success |
      | "!@#$CN%^" | 200                  | account_details_saved_success |


  @valid
    Examples: 11 characters long with 5 and 6th character matching country code
      | swift_code    | expected_http_status | expected_response             |
      # upper case
      | "ABCDCNEFGHI" | 200                  | account_details_saved_success |
      | "1234CN78910" | 200                  | account_details_saved_success |
      # special and white characters
      | "    CN     " | 200                  | account_details_saved_success |
      | "****CN*****" | 200                  | account_details_saved_success |
      | "----CN-----" | 200                  | account_details_saved_success |
      | "!@#$CN%^)(*" | 200                  | account_details_saved_success |


  @invalid
    Examples: Different length and 5, 6th characters not 'CN'
      | swift_code                                 | expected_http_status | expected_response               |
      # 8 characters long but 5th and 6th char different than CN
      | "ICBKHZBJ"                                 | 400                  | invalid_swift_code_error_for_CN |
      | "ICBKUKBJ"                                 | 400                  | invalid_swift_code_error_for_CN |
      # 8 characters long but lower case 'us'
      | "1234cn78"                                 | 400                  | invalid_swift_code_error_for_CN |
      | "abcdcnef"                                 | 400                  | invalid_swift_code_error_for_CN |
      # 11 characters long but lower case 'us'
      | "1234cn78910"                              | 400                  | invalid_swift_code_error_for_CN |
      | "abcdcnefghi"                              | 400                  | invalid_swift_code_error_for_CN |
      #boundary lengths 7,9,10,12 with 5,6th characters as CN
      | "1234CN7"                                  | 400                  | swift_code_length_error         |
      | "1234CN789112"                             | 400                  | swift_code_length_error         |
      # more than 8/11 chars and special chars
      | "&reg;>'>%AE"                              | 400                  | invalid_swift_code_error_for_CN |
      | "ñ語中$ñ語中ñ語中"                           | 400                  | invalid_swift_code_error_for_CN |
      # more than 11 chars and special chars
      | "ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$ñ語中$"          | 400                  | swift_code_length_error         |

      # some parsing issues in running this string. Commenting it for now.
#      | "a<u>?&rega<u>?&reg;{{=>'>%AE</u>}}" | 400                  | swift_code_length_error         |
