# Example
Here is a sample setup of the kubernetes logging stack with a scaled down configuration for [kind](https://kind.sigs.k8s.io).
It can be used for experimenting and development purposes. 

Default username and passwords are defined in the chart [configuration file](https://github.com/nickytd/k8s-logging-helm/blob/master/values.yaml)

The default chart configuration supports kind based clusters.
The locations of journal logs or container logs may differ from one platform to another.


Ubuntu | Kind | Minikube
--- | --- | ---
/var/log/journal | /run/log/journal | /run/log/journal
/var/log/containers | /var/log/pods | /var/lib/docker/containers

The exact locations needs to be adjusted in the host_path value supplied to the helm chart.
```
#for kind clusters
filebeat:
  host_path: /var/log/pods

journalbeat:  
  host_path: /run/log/journal  


#for minikube
filebeat:
  host_path: /var/lib/docker/containers

journalbeat:  
  host_path: /run/log/journal
```