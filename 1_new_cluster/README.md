# New Cluster
**The goal of this chapter is to create you first EKS cluster that will allow you to run pods both on EC2 and on Fargate.**

> :warning: **EKS on Fargate is currently not available in all regions, so make sure you use one of the following regions**: US East (N. Virginia), US East (Ohio), Europe (Ireland), and Asia Pacific (Tokyo)

We will be creating our EKS cluster with the tool [eksctl](https://eksctl.io/) as it automates the majority of the work. By default if you were to run the command `eksctl create cluster` it would create an EKS cluster with 2x `m5.large` EC2 worker nodes. That is only half of what we want, as we also want to enable EKS on Fargate. What we want is a "mixed" cluster with pods running both on Fargate and on EC2. To achieve this we need to configure a Fargate profile, which will allow us to run specific pods on Fargate. Below is a diagram of the architecture we want to achieve at the end of this chapter.
![eks fargate architecture](../assets/eks-cluster-architecture.png)

## Fargate Profile
The Fargate profile allows an administrator to declare which pods run on Fargate. This declaration is done through the profile’s selectors. Each profile can have up to five selectors that contain a namespace and optional labels. You must define a namespace for every selector. The label field consists of multiple optional key-value pairs. Pods that match a selector (by matching a namespace for the selector and all of the labels specified in the selector) are scheduled on Fargate. If a namespace selector is defined without any labels, Amazon EKS will attempt to schedule all pods that run in that namespace onto Fargate using the profile. If a to-be-scheduled pod matches any of the selectors in the Fargate profile, then that pod is scheduled on Fargate.

There are additional components in the Fargate profile but we will only focus on the selector component for now.
```json
"selectors": [
  {
    "namespace": "",
    "labels": {
      "KeyName": ""
    }
  }
]
```

The Fargate profile works slightly differently compared to using [node selectors and node labels](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) as there is no extra configuration to the pod. A cluster with a Fargate profile may schedule the pod on Fargate while a similar EKS cluster without a Fargate profile will not if the pod is running in the same namespace. Behavior like this has its benefits as the same manifests in multiple environments, at the same time the behavior may seem a bit invisible as you would need to check the EKS configuration to see how to run a pod on Fargate. For more information please refer to the [documentation](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html).

## Creating a Cluster
`eksctl` also takes a configuration file as input when creating a cluster to allow you to configure the vpc, region, node groups, etc. We will be mainly using two of these fields, `managedNodeGroups` and `fargateProfiles`. The former configures the EKS managed nodes groups. This workshop will not go into the details of managed nodes groups, all you need to know is that it will create EC2 instances that will be joined to your EKS cluster. If you want more please refer to the [documentation](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html). The latter configures the Fargate profile as was previously described.

Looking at the content of the `cluster.yaml` file located in the chapters directory we can see that a single node group is going to be created with the instance type `t2.large` with a desired capacity of two. Additionally a Fargate profile will be created that will schedule pods on Fargate that are created in the `default` namespace and have the label `env: fargate`.
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: workshop
  region: eu-west-1

managedNodeGroups:
  - name: managed-ng-1
    instanceType: t2.large
    desiredCapacity: 2
    maxSize: 4

fargateProfiles:
  - name: default
    selectors:
      - namespace: default
        labels:
          env: fargate
```

Let's create the cluster, make sure that you are located in the correct directory. It may take up to 15 minutes for the cluster to be created.
```shell
eksctl create cluster -f cluster.yaml
```

Your kubeconfig should be automatically configured by `eksctl`. Check that your cluster is up and running by getting its nodes, you should get a similar output as below with two nodes. You may be wondering where the Fargate nodes are, don't worry we will get to that in the next chapter.
```shell
$ kubectl get nodes
NAME                                                    STATUS   ROLES    AGE   VERSION
ip-192-168-60-78.eu-west-1.compute.internal             Ready    <none>   12h   v1.14.7-eks-1861c5
ip-192-168-7-1.eu-west-1.compute.internal               Ready    <none>   12h   v1.14.7-eks-1861c5
```

Congratulations! You now have a EKS cluster running both on EC2 and Fargate. Lets do something with it, so make sure that you do not remove the cluster.

[Next Chapter](../2_deploy_application)
