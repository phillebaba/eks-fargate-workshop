# Limitations
**The goal of this chapter is to understand a few of the limitations with EKS on Fargate.**

Fargate may offer a lot of ease of use features, lowering the threshold to use EKS, but it also comes with certain limitations. They may or may not be deal breakers so it is important to discuss them.

## Persistent Volumes
Persistent volumes are not supported for pods running on Fargate.

Just for fun, lets try scheduling a stateful pod on Fargate.
```shell
kubectl apply -f stateful_test.yaml
```

The pod will have the status `Pending` forever, and if you describe the pod you should see a similar event to below. So if you ever face this problem you know the reason why scheduling on Fargate does not work.
```
Warning  FailedScheduling  <unknown>  fargate-scheduler  Pod not supported on Fargate: volumes not supported: test-volume
```

Make sure to delete the pod when you are done.
```shell
kubectl delete -f stateful_test.yaml
```

## Scheduling Time
Head to head scheduling a pod on Fargate will be slower than EC2. This is most likely because when running on Fargate a microVM has to be created and kubelet has to start and join the cluster before the pod can be started. It is understandable that Fargate would be slower, but how much slower is it?

Measure the time it takes for a pod to complete on Fargate and EC2.
```shell
./meaure_time.sh
```

The EC2 job will complete in a couple of seconds while the Fargate job will take around two to four minutes to complete. The job is set to always pull the image, even if it is very small, to remove any benefit that the EC2 job may get from not having to pull the image. It was not a surprise that the Fargate job would take longer, but it something to be aware of. A counter argument that could be made is that in the long run the times will even out. A worker node under load may take significantly longer to start a pod. Additionally if the cluster would have to scale to provide for the resource requests Fargate would be faster than EC2.

[Next Chapter](../6_cleanup)

