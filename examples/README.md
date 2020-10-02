
Here is a sample setup of the kubernetes logging stack with a scaled down configuration for [minikube](https://minikube.sigs.k8s.io/docs/).
It can be used for experimenting and development purposes. 

minikube config 
- cpus: 4
- memory: 8192

With [minikube tunnel](https://minikube.sigs.k8s.io/docs/handbook/accessing/) for MacOS the LoadBalancer type of K8S services are exposed and FQDN are resolvable from the localhost. (http://kibana.logging.svc.cluster.local)

Default username and passwords are defined in the chart [configuration file](https://github.com/nickytd/k8s-logging-helm/blob/master/values.yaml)

When docker driver is used, then following configuration can be added to local /privete/etc/hosts (on MacOS)
```
127.0.0.1 es.logging.svc.cluster.local es
127.0.0.1 kibana.logging.svc.cluster.local kibana