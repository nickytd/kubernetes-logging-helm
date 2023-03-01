---
title: "How to generating cluster ID"
linkTitle: "How to generating cluster ID"
weight: 15
type: "docs"
description: >
    How to generating cluster ID
---

Cluster ID is required for each Kafka instance to know, to which instance it must to connect and make cluster. It is also used to [preparing storage space](https://kafka.apache.org/documentation/#kraft_storage). We need to set all Kafka instance same cluster ID. If you omit this settings, all Kafka instance generate their own ID and reject make cluster.

There is many ways, how to generate the ID, but I recommend use this chain of Bash command:

  ```bash
  $ cat /proc/sys/kernel/random/uuid | tr -d '-' | base64 | cut -b 1-22
  ```

You can also use [built-in script](https://kafka.apache.org/33/documentation.html#quickstart_startserver):

  ```bash
  $ bin/kafka-storage.sh random-uuid
  ```

Or just start one Kafka instance without the cluster ID settings and it will be generated to the logs.

_Sources_:

[Blog sleeplessbeastie.eu](https://sleeplessbeastie.eu/2021/10/22/how-to-generate-kafka-cluster-id/)<br>
[Apache Kafka Documentation](https://kafka.apache.org/33/documentation.html)