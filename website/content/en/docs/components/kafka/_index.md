---
title: "Kafka"
linkTitle: "Kafka"
weight: 15
type: "docs"
description: >
    Configuration settings for Kafka
---

Kubernetes logging helm chart deploys [Apache Kafka](https://kafka.apache.org/) as a message broker between FluentBit and Logstash for improving stability and loadbalance in big deployments.

From helm chart version **4.6.0** we omited [Apache ZooKeeper](https://zookeeper.apache.org/) as Kafka dependency. Kafka from version [**2.8.0**](https://cwiki.apache.org/confluence/display/KAFKA/KIP-500%3A+Replace+ZooKeeper+with+a+Self-Managed+Metadata+Quorum) introduced [*KRaft*](https://developer.confluent.io/learn/kraft/) aka ZooKeeper-less mode. From Kafka version [**3.3.0**](https://cwiki.apache.org/confluence/display/KAFKA/KIP-833%3A+Mark+KRaft+as+Production+Ready) is KRaft marked as production ready, so, we decide to adopt it in the logging helm chart to save some resources and deploying time. Kafka in Raft mode need to have generated cluster ID. Please check [how to generating cluster ID](https://pages.github.tools.sap/cs-devops/kubernetes-logging-helm/docs/components/kafka/howtos/clusterid/).
