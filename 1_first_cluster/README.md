# New Cluster
The goal of this chapter is to create you first EKS cluster that will allow you to run pods both in normal EC2 workers and on Fargate.

<aside class="warning">
EKS on Fargate is currently not availible in all regions, so make sure you use one of the following regions: US East (N. Virginia), US East (Ohio), Europe (Ireland), and Asia Pacific (Tokyo)
</aside>

We will be creating our EKS cluster with [eksctl](https://eksctl.io/) as it automates the creation of the cluster and all the configurations very well. By default if you were to run the command `eksctl create cluster` it would create an EKS cluster with 2x `m5.large` EC2 worker nodes. This is not enough if we also want to enable Fargate for the EKS cluster. For this workshop we want to have a "mixed" cluster with both pods running on Fargate and on EC2, the end result will be similar to the diagram below.
![eks fargate architecture](../assets/eks-fargate-architecture)

`eksctl` also takes a configuration file as input when creating a cluster to allow you to configure the vpc, region, node groups, etc. We will be focusing on two fiels, `managedNodeGroups` and `fargateProfiles`. The former is pretty self exlanitory, it specifies the configurations for the managed EC2 based node groups for the cluster. The latter is slightly more complicated as it is a new concept created to allow EKS to run on Fargate.

Fargate profiles works slightly
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
          scheduler: fargate
```

Let's create the cluster, make sure that you are located in the correct directory.
```shell
eksctl create cluster -f cluster.yaml
```

Your kubeconfig should be automatically configured by `eksctl`. Check that your cluster is up and running by getting its nodes, you should get a similar output as below with two nodes.
```shell
$ kubectl get nodes
NAME                                                    STATUS   ROLES    AGE   VERSION
ip-192-168-60-78.eu-west-1.compute.internal             Ready    <none>   12h   v1.14.7-eks-1861c5
ip-192-168-7-1.eu-west-1.compute.internal               Ready    <none>   12h   v1.14.7-eks-1861c5
```

Congratulations! You now have a EKS cluster running both on EC2 and Fargate. Lets do something with it, so make sure that you do not remove the cluster.

[Next Chapter](../2_deploy_application)
