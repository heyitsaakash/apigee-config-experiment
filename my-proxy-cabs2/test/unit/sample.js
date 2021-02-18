//sinon is required to mock objects
var sinon = require('sinon');
var assert = require('assert');


// this is the javascript file for which the mocha test cases are written 

global.context = {
    getVariable: function (s) { },
    setVariable: function (s) { }
};

global.httpClient = {
    send: function (s) { }
};

global.Request = function (s) {
};

// This method will be executed before every it() method in the test script
beforeEach(function () {
    // Stubbing Apigee objects and the methods we require 
});

// This method will restore all stubbed methods back to their original state
afterEach(function () {
});

describe('Simple Math Test', () => {
    it('should return 2', () => {
        assert.equal(2, 2);
    });
    it('should return 10', () => {
        assert.equal(10, 10);
    });
});
