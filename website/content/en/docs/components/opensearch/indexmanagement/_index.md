---
title: "Index Management"
linkTitle: "Index Management"
weight: 5
type: "docs"
description: >
  Overview on supported OpenSearch index management scenarios
---

The helm chart maintains retention days for indices in OpenSearch using a [ISM policy](https://opensearch.org/docs/latest/im-plugin/ism/index/) defined in file [`index-retention_policy.json`](https://github.com/nickytd/kubernetes-logging-helm/blob/main/chart/index-templates/index-retention_policy.json). Value is taken from `opensearch.retentionDays` key.

> **Note:** Retention period configured in the helm chart (7 days by default) shall reflect the size of the persistence volumes mounted by the OpenSearch data nodes. If the logs volume in the cluster is high, the data nodes PVs sizes shall correspond.
>
> It is a good practice to have a resizable storage class in the cluster supporting updates on the persistence volumes. When the persistence volumes fill up, the OpenSearch data node switch to read-only mode and new logs are prevented from indexing.
