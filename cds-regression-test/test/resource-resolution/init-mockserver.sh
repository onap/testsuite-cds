#!/bin/bash

curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d '{
  "httpRequest" : {
    "method" : "GET",
    "path" : "/get"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"get:ok\"}"
  }
}'

curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d '{
  "httpRequest" : {
    "method" : "POST",
    "path" : "/post"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"post:ok\"}"
  }
}'

curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d '{
  "httpRequest" : {
    "method" : "PUT",
    "path" : "/put"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"put:ok\"}"
  }
}'

curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d '{
  "httpRequest" : {
    "method" : "PATCH",
    "path" : "/patch"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"patch:ok\"}"
  }
}'

curl -v -X PUT "http://$MOCKSERVER_URL:$MOCKSERVER_PORT/mockserver/expectation" -d '{
  "httpRequest" : {
    "method" : "DELETE",
    "path" : "/delete"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"delete:ok\"}"
  }
}'
