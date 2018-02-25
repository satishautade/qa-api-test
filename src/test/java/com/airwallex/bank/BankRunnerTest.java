package com.airwallex.bank;

import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Karate.class)
@CucumberOptions(features = {
        "src/test/java/com/airwallex/bank/bank_mandatory_fields_sanity.feature",
        "src/test/java/com/airwallex/bank/add_LOCAL_banks_account_number_validation.feature",
        "src/test/java/com/airwallex/bank/add_LOCAL_banks_account_name_validation.feature",
        "src/test/java/com/airwallex/bank/add_SWIFT_banks_account_name_validation.feature",
        "src/test/java/com/airwallex/bank/add_SWIFT_banks_account_number_validation.feature",
        "src/test/java/com/airwallex/bank/add_overseas_banks_SWIFT.feature"
},
        format = {"pretty", "html:reports"},
        tags = { "~@ignore" }
)
public class BankRunnerTest {

}
