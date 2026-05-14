# Local GitOps Sandbox
A zero-cost local SRE and GitOps testing pipeline built to evaluate declarative multi-tenant cluster configurations.

## Architecture Components
- **Infrastructure as Code:** OpenTofu configuration managing local Minikube cluster nodes on a Docker Desktop runtime.
- **Continuous Delivery Engine:** ArgoCD deployed via Helm automation to manage GitOps infrastructure state tracking.
- **Target Workload:** Self-healing multi-replica Nginx application architecture deployed via declarative Kubernetes manifests.
