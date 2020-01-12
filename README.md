# EKS Fargate Workshop
TL;DR: EKS on Fargate is cool so go the [Setup](./0_setup) to start the workshop!

Welcome to this workshop that will be centered around using EKS on Fargate. In the end you should be comfortable creating EKS clusters with pods deployed on Fargate in parallel with EC2 worker nodes. To get the most of this workshop it is recommended to have some basic knowledge of Kubernetes and AWS, but it is possible do without.

## Introduction
Since Amazon released EKS on Fargate back in December 2019, people have been trying to figure out what to do with it. If we go by the purpose Amazon states in their release post, EKS on Fargates main purpose is to lower the complexity and threshold for customers to use Kubernetes on AWS.

> With AWS Fargate, customers don't need to be experts in Kubernetes operations to run a cost-optimized and highly-available cluster. Fargate eliminates the need for customers to create or manage EC2 instances for their Amazon EKS clusters.
> <br/>
> <br/>
> Customers no longer have to worry about patching, scaling, or securing a cluster of EC2 instances to run Kubernetes applications in the cloud. Using Fargate, customers define and pay for resources at the pod-level. This makes it easy to right-size resource utilization for each application and allow customers to clearly see the cost of each pod.

[Amazon EKS on AWS Fargate Now Generally Available](https://aws.amazon.com/blogs/aws/amazon-eks-on-aws-fargate-now-generally-available/)

Even considering the large pricing differences with EC2 and Fargate at may be beneficial for teams that are small or are new to Kuberntes to start off with Fargate. What other uses are there other than newcomers to Kubernetes?
* Cron jobs that dont fit into Lambda due to resource requirements or execution time.
* Small workloads that have periodic load, such as websites that are only used during the day and little to no use during the night.
* Running E2E test that require a lot of resources for short periods of time.

There is no gaurantee that everyone has a usecase that works well with Fargate, but understanding how EKS on Fargate works is the first step to identifying such workloads.

## Chapters
This workshop is split into chapters, where each chapter will focus on a specific subject. Chapters will depend on work done in previous chapters, so it is recommended to do them in order.
<ol start="0">
  <li><a href="./0_setup">Setup</a></li>
  <li><a href="./1_new_cluster">New Cluster</a></li>
  <li><a href="./2_deploy_application">Deploy Application</a></li>
  <li><a href="./3_pod_resources">Pod Resources</a></li>
  <li><a href="./4_autoscaling">Autoscaling</a></li>
  <li><a href="./5_limitations">Limitations</a></li>
  <li><a href="./6_cleanup">Cleanup</a></li>
</ol>

## Useful Resources
* [AWS re:Invent 2019: Running Kubernetes Applications on AWS Fargate](https://www.youtube.com/watch?v=m-3tMXmWWQw)
* [eksworkshop.com](https://eksworkshop.com/)
* [EKS Docs](https://aws.amazon.com/eks/)
* [EKS Fargate Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
* [EKS + Fargate = Extensibility of Kubernetes + Serverless Benefits](https://itnext.io/eks-fargate-extensibility-of-kubernetes-serverless-benefits-77599ac1763)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

