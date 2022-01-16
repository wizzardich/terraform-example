# DevOps Assignment

The purpose of this assignment is to get a feel of level of your experience of technologies that would be the main scope of work for a DevOps engineer at Vinted. On the other hand, we evaluate as well how quickly you can pick up new knowledge.


## Requirements Checklist

### Architecture

![app architecture](/devops_assignment.jpg)

### Base requirements

#### Build Docker images for `express-app` and `flask-app`
Since you will be working locally (without a cloud Docker registry) you will have to push the docker images to the local minikube or kind cluster, instructions for that can be found there:

- [minikube](https://minikube.sigs.k8s.io/docs/handbook)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#loading-an-image-into-your-cluster)

#### Set up Kubernetes cluster using Terraform
You can follow this [guide](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started) on how to get started with Kubernetes on terraform (feel free to use any public terraform module). 
You can use `kind` or `minikube` as your local K8S cluster. 

#### Install Kubernetes resources 

  - The environment variables needed by the apps must be configured via kubernetes resources
  - The endpoint `/flask/fib` in the flask service *must not* publicly exposed
  - The back-end services are deployed in the `backend` namespace and the front-end services in the `frontend` namespace
  - Accessing resources in the cluster should be done only via an ingress controller 

### Additional requirements

#### Auto scaling
  - Auto-scaling based on cpu/ram consumption (for generating more cpu/memory usage any of the services can be modified as needed)
  - All taken steps to implement and test are listed
#### Monitoring:
  - Configure basic cluster monitoring for nodes and pods with Prometheus and consume statistics
