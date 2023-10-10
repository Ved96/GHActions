######################### aws_eks_cluster ####################################
###asdkfhhf### assafdsdaf
resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  role_arn                  = var.eks_cluster_role_arn
  enabled_cluster_log_types = var.cluster_enabled_log_types
  dynamic "encryption_config" {
    for_each = var.encryption_config
    content {
      resources = encryption_config.value.encryption_config_resources
      dynamic "provider" {
        for_each = encryption_config.value.provider
        content {
          key_arn = provider.value.key_arn
        }
      }
    }
  }
  vpc_config {
    subnet_ids              = var.cluster_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access == true ? var.cluster_endpoint_public_access_cidrs : null
    security_group_ids      = var.cluster_security_group_ids
  }
  dynamic "kubernetes_network_config" {
    for_each = var.kubernetes_network_config != null ? var.kubernetes_network_config : []
    content {
      ip_family         = lookup(kubernetes_network_config.value, "ip_family")
      service_ipv4_cidr = lookup(kubernetes_network_config.value, "service_ipv4_cidr")
      service_ipv6_cidr = lookup(kubernetes_network_config.value, "service_ipv6_cidr")
    }
  }
  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? var.outpost_config : []
    content {
      control_plane_instance_type = lookup(outpost_config.value, "control_plane_instance_type")
      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement
        content {
          group_name = lookup(control_plane_placement.value, "group_name")
        }
      }
      outpost_arns = lookup(outpost_config.value, "outpost_arns")
    }
  }
  version = var.aws_eks_cluster_version
  tags    = var.eks_cluster_tag_name
}

########################### aws_eks_node_group #####################

resource "aws_eks_node_group" "worker_node_group" {
  for_each               = { for worker_node_group in var.worker_node_group : worker_node_group.eks_worker_node_group_name => worker_node_group }
  cluster_name           = aws_eks_cluster.eks_cluster.name
  node_group_name        = each.value.eks_worker_node_group_name
  node_role_arn          = each.value.node_role_arn
  subnet_ids             = each.value.subnet_ids
  instance_types         = each.value.instance_types
  ami_type               = each.value.ami_type
  capacity_type          = each.value.capacity_type
  node_group_name_prefix = each.value.node_group_name_prefix
  disk_size              = each.value.disk_size
  force_update_version   = each.value.force_update_version
  labels                 = each.value.labels
  release_version        = each.value.release_version
  version                = each.value.worker_version
  dynamic "remote_access" {
    for_each = each.value.remote_access
    content {
      ec2_ssh_key               = lookup(remote_access.value, "ec2_ssh_key")
      source_security_group_ids = lookup(remote_access.value, "source_security_group_ids")
    }
  }
  dynamic "launch_template" {
    for_each = each.value.launch_template
    content {
      id      = lookup(launch_template.value, "id")
      name    = lookup(launch_template.value, "name")
      version = lookup(launch_template.value, "launch_template_version")
    }
  }
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }
  dynamic "taint" {
    for_each = each.value.taint
    content {
      key    = lookup(taint.value, "key")
      value  = lookup(taint.value, "value")
      effect = lookup(taint.value, "effect")
    }
  }
  tags = each.value.eks_worker_node_group_tag_name
}

############################# aws_eks_addon ########################################

resource "aws_eks_addon" "addons" {
  for_each                 = { for addon in var.addons : addon.name => addon }
  cluster_name             = aws_eks_cluster.eks_cluster.name
  addon_name               = each.value.name
  addon_version            = each.value.version
  resolve_conflicts        = each.value.resolve_conflicts
  configuration_values     = each.value.configuration_values
  preserve                 = each.value.preserve
  service_account_role_arn = each.value.service_account_role_arn
  tags                     = each.value.addon_tag_name
}

#################aws_eks_fargate_profile#########################

resource "aws_eks_fargate_profile" "fargate_profile" {
  for_each               = var.fargate_profile != null ? var.fargate_profile : {}
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = each.value.fargate_profile_name
  pod_execution_role_arn = each.value.pod_execution_role_arn
  dynamic "selector" {
    for_each = each.value.selector
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }
  subnet_ids = each.value.subnet_ids_fargate
  tags = each.value.tags
}
