output "eks_cluster_id" {
  description = "The ID of your local Amazon EKS cluster on the AWS Outpost"
  value       = module.eks-cluster-module.eks_cluster_id
}

