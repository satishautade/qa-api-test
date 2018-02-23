package com.airwallex.bank;

import com.intuit.karate.junit4.Karate;
import cucumber.api.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Karate.class)
@CucumberOptions(features = {
                      "src/test/java/com/airwallex/bank/bank_mandatory_fields.feature"
                },
                format = {"pretty", "html:reports"},
                tags = {}
                )
public class BankRunnerTest {

}
