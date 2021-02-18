'use strict';

const apickli = require('apickli');
const {Before} = require('cucumber');

//obtain the environment configurations
var config = require('../../test-config.json');

console.log('config info api: [' + config.myApigeeApi.domain + ', ' + config.myApigeeApi.basepath + ']');

Before(function() {
    //this.apickli = new apickli.Apickli('http', 'httpbin.org');

   
	this.apickli = new apickli.Apickli('https',config.myApigeeApi.domain + config.myApigeeApi.basepath);
    //this.apickli = new apickli.Apickli('https', 'eu-west1-partner26-test.apigee.net');
   // this.apickli = new apickli.Apickli('https', 'eu-west1-partner26-test.apigee.net');
    this.apickli.addRequestHeader('Cache-Control', 'no-cache');
});

/*'use strict';

const apickli = require('apickli');
const {defineSupportCode} = require('cucumber');



defineSupportCode(function({Before}) {
    Before(function() {
        this.apickli = new apickli.Apickli('https', 'onlineman477-eval-prod.apigee.net');
        this.apickli.addRequestHeader('Cache-Control', 'no-cache');
    });
});
defineSupportCode(function({setDefaultTimeout}) {
    setDefaultTimeout(60 * 1000); // this is in ms
});*/