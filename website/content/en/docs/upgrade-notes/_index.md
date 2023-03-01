---
title: "Upgrade Notes"
linkTitle: "Upgrade Notes"
weight: 10
type: "docs"
---

# 2.x -> 3.0.0
Since version 3.0.0, the chart values are renamed and follow [camel case recommendation](https://helm.sh/docs/chart_best_practices/values/). This is a backward **incompatibility change** and helm chart values for releases needs first to be migrated to the recommended camel case format.

# 4.5.4 -> 4.6.0
In the version **4.6.0** we omited [Apache ZooKeeper](https://zookeeper.apache.org/) as Kafka dependency. In Raft mode Kafka cluster need to have generated cluster ID. Please check [how to generating cluster ID](https://nickytd.github.io/kubernetes-logging-helm/docs/components/kafka/howtos/clusterid/) and change your `values.yaml` file accordingly.

If you dont want lost any of your log data in upgrading, here is a safe procedure:
- delete FluentBit daemonset (this stop feeding Kafka with new log data)
- wait, until Logstash process all cached log records from Kafka to OpenSearch (checking is possible via monitoring API or in Grafana Dashboard)
- scale down Kafka StatefulSet to zero (this delete old Kafka implementation)
- delete Kafka StatefulSet
- scale down ZooKeeper StatefulSet to zero
- delete ZooKeeper StatefulSet
- delete PersistantVolumeClaim for Kafka's and for ZooKeeper's instances as well
- do `helm upgrade ...`