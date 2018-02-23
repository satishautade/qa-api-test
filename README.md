# Running from command line

```sh
cd /path/to/qa-api-test
mvn clean test
```
By default this executes the test on http://preview.airwallex.com:30001
To change it to demo ( http://preview.airwallex.com:30001) run
```sh
mvn clean test -Dkarate.env=demo
```
The generated HTML reports for test runs can be found under 
`qa-api-test/target/surefire-reports`

 # Bugs
 I have created cucumber tags for each bug found. To reproduce any bug please run  tag `@bug` followed by its number in the list.
 E.g. To reproduce bug no. 3 run
 ```sh
 mvn test -Dcucumber.options="--tags @bug3"
 ```
 #### Bugs Found
 1. For US, account_number = " " should NOT pass the validation but it does. It works as expected for AU and CN countries

## Improvements/Suggestions

  1. The convention is to return HTTP `201 - Created` when a resource gets created on the server. Reference https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/201. Consider returning the same after a successful POST of the account information as account resource gets created in this case. 