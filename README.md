[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kubernetes-logging)](https://artifacthub.io/packages/search?repo=kubernetes-logging) ![Release Charts](https://github.com/nickytd/kubernetes-logging-helm/workflows/Release%20Charts/badge.svg) ![Publis Documentation](https://github.com/nickytd/kubernetes-logging-helm/workflows/Publish%20Documentation/badge.svg)

# kubernetes-logging-helm with [Opensearch](https://opensearch.org)

This helm chart deploys a scalable containerized logging stack, enabling log observability for kubernetes applications with Opensearch. The deployment may take various forms, from a single node setup usable for a local development up to scaled multi nodes opensearch deployments used in production environments. It is an easy way to provision a managed Opensearch cluster with optional kafka brokers, flunetbits and logstash(s) supplying additional initialization steps for the various components.

![Kubernetes Logging Stack](website/static/k8s-logging-stack.jpg)


## Adding the helm chart repository:
```
helm repo add logging https://nickytd.github.io/kubernetes-logging-helm
helm repo update
```

```bash
helm install ofd logging/kubernetes-logging
```

Pages: https://nickytd.github.io/kubernetes-logging-helm

Uprgade Notes 2.x to 3.0.0:
Since version 3.0.0, the chart values are renamed and follow camel case recommendation.

Chart version 4.0.0 now features Opensearch & Dashboards 2.0.0 - [Release Notes](https://github.com/opensearch-project/OpenSearch/blob/main/release-notes/opensearch.release-notes-2.0.0.md)
