[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/kubernetes-logging-helm)](https://artifacthub.io/packages/search?repo=kubernetes-logging-helm)
# kubernetes-logging-helm

This is a comprehensive helm chart for deploying complete Kubernetes logging stack featuring few design options suitable from a minikube/kind setup up to a scaled production grade deployment capable of processing billions of records.

![Containers Logs](https://github.com/nickytd/kubernetes-logging-helm/blob/master/images/k8s-logging-stack.jpg)

Here is a [setup example](https://github.com/nickytd/kubernetes-logging-helm/tree/master/examples) for local development and testing based on [kind](https://kind.sigs.k8s.io)

Start a sample provisioning with setting up a local cluster, followed by deployment of the logging stack.
[examples/setup-cluster.sh](https://github.com/nickytd/kubernetes-logging-helm/blob/master/examples/setup-cluster.sh)
[examples/install-elk.sh](https://github.com/nickytd/kubernetes-logging-helm/blob/master/examples/install-elk.sh)


Provisioning options:
By default the helm chart setup following components:
 1. Elastic coordination node
 1. Elastic master node
 1. Elastic data node
 1. Filebeat
 1. Journalbeat
 1. Logstash
 1. Kibana
 
In this option setup, the beats directly talk to the logstash instance. 

There are two options to scale the setup:
* For medium logging stream volumes the chart can be horizontally scaled by increasing the replicas of the Elastic nodes and Logstash deployment.
M size example for indexing less than 1 000 000 docs per min [M-size-k8s-logging-values.yaml](https://github.com/nickytd/kubernetes-logging-helm/blob/master/examples/M-size-k8s-logging-values.yaml)

* For high logging stream volume a Kafka broker can be enabled in the chart so the beats( or application pods sidecars) can push logs to the Kafka topics. Then the Logstash fetches the logs stream from the Kafka queues and the outputs to the dedicated Elasticsearch instance. 

L size example for indexing more than 1 000 000 docs per min [L-size-k8s-logging-values.yaml](https://github.com/nickytd/kubernetes-logging-helm/blob/master/examples/L-size-k8s-logging-values.yaml)

The logging stream has dedicated Elasticsearch indices. The stdout and stderr from containers are pushed to "containers-<date>" indices and the systemlog of the hosts, if journabeat is enabled. is pushed to "journals-<date>".

The chart also supports external(outside the cluster) Elasticsearch instance. In this configuration no elastic (coordination, data, master) nodes will be provisioned by the helm chart.

Kibana by default comes with 2 predefined dashboards and set of searches
1. Containers logs dashboard, grouping container logs per namespace and pod
![Containers Logs](https://github.com/nickytd/kubernetes-logging-helm/blob/master/images/LogStream.png)
2. Journals logs dashboard, grouping systemlogs per system unit and node
![Journals Logs](https://github.com/nickytd/kubernetes-logging-helm/blob/master/images/JournalLogs.png)

Usually logs are searched and inspected via the Discovery view
1. Containers Logs in Discovery View
![Containers Logs](https://github.com/nickytd/kubernetes-logging-helm/blob/master/images/ContainersLogs.png)
1. Containers Logs enhanced with Kubernetes metadata. 
![Containers Logs](https://github.com/nickytd/kubernetes-logging-helm/blob/master/images/LogswithMetadata.png)

```
In Kibana multi tenant layout is also supported. The Helm chart sets up a Developer tenant with the corresponding role having read/write permission in the tenant space.
