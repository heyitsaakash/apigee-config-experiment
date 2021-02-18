  //getting traceId from request header. 
var traceId = context.getVariable("request.header.X-TraceId");
//print("traceId==" + traceId);
//generating spanId for Apigee Logging.
var d = new Date().getTime();
var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
var r = (d + Math.random() * 16) % 16 | 0;
return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
});
var uuidStrip = (uuid.substring(0, 8) + uuid.substring(9, 13) + uuid.substring(14, 18));
//Assigning above generated unique code in spanId
var spanId = uuidStrip;
//If traceId is not received in request header Apigee is generating it.
if (!traceId) {
traceId = uuidStrip;
}

context.setVariable("apigee.example.traceId", traceId);
context.setVariable("apigee.example.spanId", spanId);
