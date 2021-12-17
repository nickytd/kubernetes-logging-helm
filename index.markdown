---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

![Kubernetes Logging Stack](images/opensearch-k8s.png)

This helm chart deploys a scalable containerized logging stack with the main purpose of enabling log observability for kubernetes applications. The design supports both local development use cases such as minikube deployments up to a scaled production scenarios. The latter scenarios leverage kafka message broker, completely decoupling in this way,  the log generation and log indexing functions.

The helm chart supports opensearch in various configurations starting from a single node setup usable for local development, to a scaled multi nodes opensearch deployment suitable for production environment. In the latter case there are 3 types of nodes (coordination, data and master) where each of those can be both horizontally and vertically scaled depending on the load and shards replication demands.

Finally this helm chart provides index templates management in opensearch and index pattern management in opensearch-dashboards. An initial predefined set of dashboards is also provided for illustration purposes.

![Kubernetes Logging Stack](images/k8s-logging-stack.jpg)

## Adding the helm chart repository:
{% highlight bash %}
helm repo add logging https://nickytd.github.io/kubernetes-logging-helm
helm repo update
{% endhighlight %}

## Install a release
{% highlight bash %}
helm install ofd logging/kubernetes-logging
{% endhighlight %}

Uprgade Notes 2.x to 3.0.0:
Since version 3.0.0, the chart values are renamed and follow camel case recommendation.

<h2>{{ site.data.deployments.docs_list_title }}</h2>
<ul>
   {% for item in site.data.deployments.docs %}
      <li><a href="{{ item.url }}">{{ item.title }}</a></li>
   {% endfor %}
</ul>