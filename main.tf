terraform {
  required_version = ">= 1.6.0"
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "~> 0.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}

# 1. Point OpenTofu to your active local Docker Desktop engine
provider "minikube" {}

# 2. Command OpenTofu to build the cluster container inside Docker
resource "minikube_cluster" "sre_sandbox" {
  driver       = "docker"
  cluster_name = "sre-local-sandbox"
  cpus         = 2
  memory       = "4000mb"
}

# 3. Configure Kubernetes access parameters
provider "kubernetes" {
  host                   = minikube_cluster.sre_sandbox.host
  client_certificate     = minikube_cluster.sre_sandbox.client_certificate
  client_key             = minikube_cluster.sre_sandbox.client_key
  cluster_ca_certificate = minikube_cluster.sre_sandbox.cluster_ca_certificate
}

# 4. Configure Helm tracking parameters
provider "helm" {
  kubernetes {
    host                   = minikube_cluster.sre_sandbox.host
    client_certificate     = minikube_cluster.sre_sandbox.client_certificate
    client_key             = minikube_cluster.sre_sandbox.client_key
    cluster_ca_certificate = minikube_cluster.sre_sandbox.cluster_ca_certificate
  }
}

# 5. Build an isolated tracking namespace inside the cluster
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# 6. Pull down and inject the ArgoCD engine into that namespace
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.52.0"
}
