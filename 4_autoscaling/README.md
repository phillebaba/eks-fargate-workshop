# Autoscaling
**The goal of this chapter is to set up autoscaling for pod running on Fargate**

Now that we understand how resource allocation works with EKS on Fargate it's about time we look into autoscaling. Autoscaling is a major selling point of both Kubernetes and running on the cloud. Within Kuberntes there are three different types of scaling.
Cluster autoscaling adds nodes to the cluster when there are not enough resources available on the nodes to fulfill the requests.
Horizontal pod autoscaling (HPA) scales the number of pods based on CPU utilization or any other custom metric.
Vertical pod autoscaling (VPA) will automatically set and change the resource limits and requests for a pod based on its historical resource usage.
It should be noted that at the moment HPA and VPA can not be used in tandem on the same pod.

By now it should be obvious that the cluster autoscaler is not applicable to Fargate. The main selling put of using Fargate with EKS is the fact that there are no nodes that have to be scaled. Resources are requested by the pod and they are immediately available. Both HPA and VPA depends on metrics-server to work, which we have already used in the previous chapter. So it should work without any issue, you haven't removed the metrics-server right?

## HPA
HPA works by creating a separate resource that defines among others a target deployment, max and min amount of replicas, and the target metric that should trigger a scaling event. The metrics can either come from the metrics-server running in the cluster or be a custom metric that has been collected by Prometheus.
![hpa](../assets/hpa.png)

We will be using the resource-consume application once again, but this time we will also create a HPA to go along with the deployment. For this example we have configured the HPA to scale when the memory usage exceeds 50% of the memory request. The deployment will request 500 millicores and 500 Mb memory.
```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: resource-consumer
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: resource-consumer
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 50
```

Apply the resource consumer application with the HPA.
```shell
kubectl apply -k resource_consumer_hpa
kubectl wait --timeout 5m --for=condition=available deployment/resource-consumer
```

Consume resources to cause the trigger the HPA and increase the amount of pods.
```shell
EXTERNAL_IP=$(kubectl get service -l app=resource-consumer -o=jsonpath="{.items[0].status.loadBalancer.ingress[0].hostname}")
curl --data "megabytes=300&durationSec=180" http://$EXTERNAL_IP:8080/ConsumeMem
watch -n 1 kubectl get pod -l app=resource-consumer
```

After about a minute you should see the HPA kick in and increase the replica count of the deployment. Rather uneventful if you have used the HPA before, but the cool part is that this could scale forever (until the soft limit of 100 pods per region or the hard limit of 5000 pods per cluster).

Hold on a minute! The closest Fargate compute configuration to our resource request is 500 millicores and 1Gb memory. Which means that `300Mb / 1000Mb != 50%`. It turns out that the HPA will make its scaling decision based on the resource request and not what is actually allocated in Fargate.

Before moving on to the next chapter make sure to remove the resource-consumer application.
```shell
kubectl delete deployment resource-consumer && kubectl delete service resource-consumer && kubectl delete hpa resource-consumer
```

[Next Chapter](../5_limitations)
