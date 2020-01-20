# Fargate Profile
**The goal of this chapter is to understand how Fargate Profiles are used by the pod scheduler.**

Fargate Profile allows an administrator to declare which pods run on Fargate. This declaration is done through the profile's selectors. Each profile can have up to five selectors that contain a namespace and optional labels. You must define a namespace for every selector. The label field consists of multiple optional key-value pairs. Pods that match a selector (by matching a namespace for the selector and all of the labels specified in the selector) are scheduled on Fargate. If a namespace selector is defined without any labels, Amazon EKS will attempt to schedule all pods that run in that namespace onto Fargate using the profile. If a to-be-scheduled pod matches any of the selectors in the Fargate profile, then that pod is scheduled on Fargate. The following parameters are part of a Fargate Profile.
```json
{
  "fargateProfileName": "",
  "clusterName": "",
  "podExecutionRoleArn": "",
  "subnets": [
    ""
  ],
  "selectors": [
    {
      "namespace": "",
      "labels": {
        "KeyName": ""
      }
    }
  ],
  "clientRequestToken": "",
  "tags": {
    "KeyName": ""
  }
}
```

The Fargate profile works slightly differently compared to using [node selectors and node labels](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) as there is no extra configuration to the pod. A cluster with a Fargate profile may schedule the pod on Fargate while a similar EKS cluster without a Fargate profile will not if the pod is running in the same namespace. Behavior like this has its benefits as the same manifests in multiple environments, at the same time the behavior may seem a bit invisible as you would need to check the EKS configuration to see how to run a pod on Fargate. For more information please refer to the [documentation](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html).

## New Namespace
We now want to add a new namespace where all pods will run on Faraget.

Create a new namespace and deploy a pod in it.
```shell
kubectl create namespace test
kubectl apply -f test-pod.yaml
```

Fargate profiles are immutable so we need to add a new Fargate Profile to include the new namespace. The following Fargate Profile will be added.
```yaml
- name: test
  selectors:
    - namespace: test
```

Update the cluster with the new modified cluster configuration files.
```shell
eksctl create fargateprofile -f new-namespace-cluster.yaml
```

The pod will not run on Fargate until it is re-scheduled. Delete the pod and create it again to reschedule the pod.
```shell
kubectl -n test delete pod test
kubectl apply -f test-pod.yaml
```

The pod is now runnin on Fargate. It is important to understand that EKS on Fargate only extends the scheduler in Kubernetes and does not alter it. In the same way that a pod will not be rescheduled if the node selector no longer matches after a nodes labels have been altered, a pod will not be moved to run on Fargate if the profile is created after the pod has been scheduled.

Delete the pod and the Fargate Profile.
```shell
kubectl -n test delete pod test
eksctl delete fargateprofile --name test -f new-namespace-cluster.yaml
```

## Pod Execution Role
// Some sort of description

Create a new role with S3 read access and that has a trust relationship to pods on Fargate.
```shell
BUCKET_NAME="test-bucket-$(date +%s)"
aws s3api create-bucket --region eu-west-1 --bucket $BUCKET_NAME --create-bucket-configuration LocationConstraint=eu-west-1
aws iam create-role --role-name s3-read --assume-role-policy-document file://role-trust-policy.json
aws iam attach-role-policy --role-name s3-read --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

Upload a test file to the bucket.
```shell
```

Create a new Fargate Profile with the execution role we just created.
```shell
ROLE_ARN=$(aws iam get-role --role-name s3-read --query "Role.Arn")
cat execution-role-cluster.yaml | envsubst | eksctl create fargateprofile -f -
```

Run the new test pod, this pod will try to read the file we added to the S3 bucket and output it to stdout. If the role works we should see the content.
```shell
kubectl apply -f s3-pod.yaml
kubectl -n test log -f s3
```

// Describe why it is useful

Delete the pod, namespace, S3 bucket, role, and Fargate Profile.
```shell
kubectl -n test delete pod test
kubectl delete ns test
aws s3api delete-bucket --region eu-west-1 --bubcket $BUCKET_NAME
eksctl delete fargateprofile --name test -f cluster.yaml
```

[Next Chapter](../4_pod_resources)

