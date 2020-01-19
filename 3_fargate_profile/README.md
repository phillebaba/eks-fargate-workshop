# Fargate Profile
**The goal of this chapter is to understand how Fargate Profiles are used by the pod scheduler.**

Fargate Profile allows an administrator to declare which pods run on Fargate. This declaration is done through the profile's selectors. Each profile can have up to five selectors that contain a namespace and optional labels. You must define a namespace for every selector. The label field consists of multiple optional key-value pairs. Pods that match a selector (by matching a namespace for the selector and all of the labels specified in the selector) are scheduled on Fargate. If a namespace selector is defined without any labels, Amazon EKS will attempt to schedule all pods that run in that namespace onto Fargate using the profile. If a to-be-scheduled pod matches any of the selectors in the Fargate profile, then that pod is scheduled on Fargate.

The Fargate profile works slightly differently compared to using [node selectors and node labels](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) as there is no extra configuration to the pod. A cluster with a Fargate profile may schedule the pod on Fargate while a similar EKS cluster without a Fargate profile will not if the pod is running in the same namespace. Behavior like this has its benefits as the same manifests in multiple environments, at the same time the behavior may seem a bit invisible as you would need to check the EKS configuration to see how to run a pod on Fargate. For more information please refer to the [documentation](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html).

Create a new namespace and deploy a pod in it.
```shell
kubectl create namespace test
kubectl apply -f pod.yaml
```

Create a new Fargate Profile in the EKS cluster.
```shell

```
// create new fargate profile
// will pod reschedule when

// execution roles

[Next Chapter](../4_pod_resources)

