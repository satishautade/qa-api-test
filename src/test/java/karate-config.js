function() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'preview';
  }
  var config = {
    env: env,
	myVarName: 'someValue'
  }
  if (env == 'preview') {
    // customize
    // e.g. config.foo = 'bar';
      baseUrl = "http://preview.airwallex.com:30001";

  } else if (env == 'demo') {
    // customize
      baseUrl = "http://demo.airwallex.com:30001";
  }
  return config;
}