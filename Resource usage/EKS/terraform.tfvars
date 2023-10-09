aws_region                = "us-west-1"
aws_profile               = "terraform"
cluster_name              = "eks-cluster"
eks_cluster_role_arn      = "arn:aws:iam::239312700453:role/terraform-eks-cluster-iam-role"
cluster_enabled_log_types = ["api", "audit", "authenticator"]
encryption_config = [
  {
    encryption_config_resources = ["secrets"]
    provider = [
      {
        key_arn = "arn:aws:kms:us-west-1:239312700453:key/11be161c-e77b-4b20-80de-58e5df2ddee7"
      }
    ]
  }
]
kubernetes_network_config = [
  {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.0.0.0/12"
  }
]
cluster_endpoint_private_access      = true
cluster_endpoint_public_access       = false
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
cluster_security_group_ids           = ["sg-096fe2af4b3561675"]
cluster_subnet_ids                   = ["subnet-00b989915f174e58a", "subnet-0f4ca19ab1da81adb"]
aws_eks_cluster_version              = "1.25"
eks_cluster_tag_name = {
  name     = "P03_ekscluster"
  p_id     = "p03"
  prj-name = "AWS GDS CIL team"
  owner    = "vedant.purushottam.kulkarni@gds.ey.com"
}
worker_node_group = [
#   {
#     desired_size = 2
#     #disk_size                  = 20
#     eks_worker_node_group_name = "terraform_node_group"
#     eks_worker_node_group_tag_name = {
#       name     = "P03_ekscluster"
#       p_id     = "p03"
#       prj-name = "AWS GDS CIL team"
#       owner    = "vedant.purushottam.kulkarni@gds.ey.com"
#     }
#     max_size      = 2
#     min_size      = 1
#     node_role_arn = "arn:aws:iam::239312700453:role/terraform-eks-workernodes-iam-role"
#     subnet_ids    = ["subnet-0c2b66c418b23e859", "subnet-05aaf6e0c5117ac6c"]
#     taint = [{
#       effect = "NO_SCHEDULE"
#       key    = "1"
#       value  = "0"
#     }]

#     force_update_version = false
#     instance_types       = ["t2.micro"]
#     labels = {
#       "kubernetes" = "linux"
#     }
#     max_size        = 3
#     min_size        = 1
#     node_role_arn   = "arn:aws:iam::239312700453:role/eks@node@role"
#     release_version = "1.24.10-20230304"
#     remote_access = [{
#       ec2_ssh_key               = "cluster"
#       source_security_group_ids = ["sg-096fe2af4b3561675"]
#     }]
#     subnet_ids = ["subnet-0c2b66c418b23e859"]
#     taint = [{
#       effect = "NO_SCHEDULE"
#       key    = "1"
#       value  = "0"
#     }]
#     worker_version = "1.24"
# }
]

addons = [
  {
    addon_tag_name = {
      name     = "P03_ekscluster"
      p_id     = "p03"
      prj-name = "AWS GDS CIL team"
      owner    = "vedant.purushottam.kulkarni@gds.ey.com"
    }
    name                     = "vpc-cni"
    preserve                 = false
    resolve_conflicts        = "OVERWRITE"
    service_account_role_arn = "arn:aws:iam::239312700453:role/terraform-eks-workernodes-iam-role"
    version                  = "v1.12.5-eksbuild.1"
  },
  {
    addon_tag_name = {
      name     = "P03_ekscluster"
  p_id     = "p03"
  prj-name = "AWS GDS CIL team"
  owner    = "vedant.purushottam.kulkarni@gds.ey.com"
    }
    name                     = "kube-proxy"
    preserve                 = false
    resolve_conflicts        = "OVERWRITE"
    service_account_role_arn = "arn:aws:iam::239312700453:role/terraform-eks-workernodes-iam-role"
    version                  = "v1.24.9-eksbuild.1"
  }
]

fargate_profile = {
   "config1" = {
     fargate_profile_name   = "fargate-EKS"
     pod_execution_role_arn = "arn:aws:iam::239312700453:role/Fargate-terraform"
     selector = [{
       namespace = "kubernetes-namespace"
     }]
     subnet_ids_fargate = ["subnet-0c2b66c418b23e859"]
     tags = {
       name     = "P03_ekscluster"
       p_id     = "p03"
       prj-name = "AWS GDS CIL team"
       owner    = "vedant.purushottam.kulkarni@gds.ey.com"
     }
   }
}


