module "eks-cluster-module" {
  source                               = "../../../Modules/Networking & Content Delivery/EKS"
  cluster_name                         = var.cluster_name
  eks_cluster_role_arn                 = var.eks_cluster_role_arn
  cluster_enabled_log_types            = var.cluster_enabled_log_types
  encryption_config                    = var.encryption_config
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_security_group_ids           = var.cluster_security_group_ids
  cluster_subnet_ids                   = var.cluster_subnet_ids
  kubernetes_network_config            = var.kubernetes_network_config
  outpost_config                       = var.outpost_config
  eks_cluster_tag_name                 = var.eks_cluster_tag_name
  aws_eks_cluster_version              = var.aws_eks_cluster_version
  worker_node_group                    = var.worker_node_group
  addons                               = var.addons
  fargate_profile                      = var.fargate_profile
}
