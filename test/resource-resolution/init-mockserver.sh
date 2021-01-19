#!/bin/bash
#
# Copyright (C) 2020 Bell Canada.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

OP=expectation
if [[ $1 == rm ]]; then
  OP=clear
fi

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "GET",
    "path" : "/mock-$CI_PIPELINE_ID/get"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"A046E51D-44DC-43AE-BBA2-86FCA86C5265\"}"
  }
}
EOF

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "GET",
    "path" : "/mock-$CI_PIPELINE_ID/get/A046E51D-44DC-43AE-BBA2-86FCA86C5265/id"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"74FE67C6-50F5-4557-B717-030D79903908\"}"
  }
}
EOF

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "POST",
    "path" : "/mock-$CI_PIPELINE_ID/post"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"post:ok\"}"
  }
}
EOF

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "PUT",
    "path" : "/mock-$CI_PIPELINE_ID/put"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"put:ok\"}"
  }
}
EOF

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "PATCH",
    "path" : "/mock-$CI_PIPELINE_ID/patch"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"patch:ok\"}"
  }
}
EOF

curl -vLk -X PUT "http://$CLUSTER_IP:$MOCKSERVER_NODEPORT/mockserver/$OP" -d @- <<EOF
{
  "httpRequest" : {
    "method" : "DELETE",
    "path" : "/mock-$CI_PIPELINE_ID/delete"
  },
  "httpResponse" : {
    "body" : "{\"value\": \"delete:ok\"}"
  }
}
EOF
