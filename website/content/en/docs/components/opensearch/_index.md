---
title: "OpenSearch"
linkTitle: "OpenSearch"
weight: 10
type: "docs"
description: >
    Configuration settings for OpenSearch
---

Kuberenetes logging helm chart supports multiple deployment layouts of OpenSearch, which both satisfy local development needs where minimum use of resources is required or production layout with additional Kafka brokers and HA setup of the various components.

By default the helm chart configures two indices with corresponding index templates. One index is `containers-{YYYY.MM.dd}` indexing by default all workloads logs and `systemd-{YYYY.MM.dd}` for storing journal system logs for "kubelet" or "containerd" services running on the respective cluster nodes.
Both indices are created according [index templates](https://opensearch.org/docs/latest/opensearch/index-templates/) allowing later on dedicated visualizations in OpenSearch Dahboards UI.

"Containers" index template uses [composable pattern](https://opensearch.org/docs/latest/opensearch/index-templates/#composable-index-templates) and leverages a predefined component template named "kubernetes-metadata".

```
containers  [containers-*]  0  [kubernetes-metadata]
systemd     [systemd-*]     0  []
```
The latter uses kubernetes metadata attached by the FluentBit log shippers to unify its structure among workloads. It shall be also used by any container specific index with the purpose of sharing the same kubernetes fields mappings.

The helm chart deploys all templates extensions found in [index-templates](https://github.com/nickytd/kubernetes-logging-helm/tree/main/chart/index-templates) folder.
An example of such index template is nginx, which inherits the mappings in the "kubernetes-metadata" component templates and adds access logs fields mappings.
```json
{
   "index_patterns":[
      "nginx-*"
   ],
   "composed_of":[
      "kubernetes-metadata"
   ],
   "template":{
      "settings":{
         "index":{
            "codec":"best_compression",
            "mapping":{
               "total_fields":{
                  "limit":1000
               }
            },
            "number_of_shards":"{{ (.Values.data.replicas | int) }}",
            "number_of_replicas":"{{ (sub (.Values.data.replicas | int) 1) }}",
            "refresh_interval":"5s"
         }
      },
      "mappings":{
         "_source":{
            "enabled":true
         },
         "properties":{
            "log":{
               "type":"text"
            },
            "agent":{
               "type":"keyword"
            },
            "code":{
               "type":"keyword"
            },
            "host":{
               "type":"keyword"
            },
            "method":{
               "type":"keyword"
            },
            "path":{
               "type":"keyword"
            },
            "proxy_upstream_name":{
               "type":"keyword"
            },
            "referrer":{
               "type":"keyword"
            },
            "reg_id":{
               "type":"keyword"
            },
            "request_length":{
               "type":"long"
            },
            "request_time":{
               "type":"double"
            },
            "size":{
               "type":"long"
            },
            "upstream_addr":{
               "type":"keyword"
            },
            "upstream_response_length":{
               "type":"long"
            },
            "upstream_response_time":{
               "type":"double"
            },
            "upstream_status":{
               "type":"keyword"
            },
            "user":{
               "type":"keyword"
            }
         }
      }
   }
}
```