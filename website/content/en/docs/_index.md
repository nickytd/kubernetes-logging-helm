---
title: "Helm chart overview"
linkTitle: "Documentation"
weight: 1
type: "docs"
---

![Basic logo](../opensearch-k8s.png)

This helm chart deploys a scalable containerized logging stack with the main purpose of enabling log observability for kubernetes applications. The design supports both local development use cases such as minikube deployments up to a scaled production scenarios. The log shippers are [FluentBits](https://fluentbit.io/) deployed on each kubernetes node mounting the host filesystem. The latter scenarios leverage [Kafka](https://kafka.apache.org/) message broker, completely decoupling in this way, the log generation and log indexing functions.

The helm chart supports [OpenSearch](https://opensearch.org/) in various configurations starting from a single node setup usable for local development, to a scaled multi nodes OpenSearch deployment suitable for production environment. In the latter case there are 3 types of nodes (coordination, data and master) where each of those can be both horizontally and vertically scaled depending on the load and shards replication demands.

Finally this helm chart provides index templates management in OpenSearch and index pattern management in [OpenSearchDashboards](https://opensearch.org/docs/latest/dashboards/index/). An initial predefined set of dashboards is also provided for illustration purposes.

![Schema](../k8s-logging-stack.jpg)

## Adding the helm chart repository:
``` bash
helm repo add cs-devops \
  https://common.repositories.cloud.sap:443/cs-devops-helm \
  --username=<username> --password=<AUTH_TOKEN>
helm repo update
```

{{% alert title="Note" %}}Any authenticated user should have **read access** to the helm repository.{{% /alert %}}

## Prepare a release configuration
The recommended approach is the get the default [helm chart values](https://github.tools.sap/cs-devops/kubernetes-logging-helm/blob/main/chart/values.yaml) and adjust accordingly.
At minimum the ingress annotations for the OpenSearch rest endpoint and OpenSearchDashboards UI app have to be adjusted. Here is an [example](https://github.tools.sap/cs-devops/kubernetes-logging-helm/blob/main/examples/single-node-setup.yaml) for a minimal single OpenSearch node setup.

## Install a release
``` bash
helm install ofd cs-devops/kubernetes-logging
````
