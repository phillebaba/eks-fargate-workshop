# Setup
This workshop will require an AWS account with permissions to create EKS clusters, if you don't already have an account you can follow [this guide](https://eksworkshop.com/020_prerequisites/self_paced/account/) to create one.

> :warning: **Please note that EKS is not included in free tier so you will accumulate costs. The costs are going to be very small if you run through the workshop in a couple of hours though.**

Before starting you need to make sure that you have installed the following tools. They will be used throughout the workshop. If you want a temporary workspace or are having trouble running the tools on Windows you can follow [this guide](https://eksworkshop.com/020_prerequisites/workspace/) to create a workspace in Cloud9.
* [eksctl](https://github.com/weaveworks/eksctl/releases) (>=0.11.0)
* [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)
* [kubectl](https://v1-13.docs.kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)

After your environment is ready, make sure clone this repository. It will be helpful as you wont have to copy paste configuration files.
```shell
git clone https://github.com/phillebaba/eks-fargate-workshop.git
```

Now that you have cloned the repository you get on with the workshop. The workshop is divided into chapters to make it easier to follow along. Some of the chapters will depend on resources created in others so make sure that you don't delete anything unless explicitly told so.

[Next Chapter](../1_new_cluster)

