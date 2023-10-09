output "eks_cluster_id" {
  description = "The ID of your local Amazon EKS cluster on the AWS Outpost"
  value       = aws_eks_cluster.eks_cluster.id
}
