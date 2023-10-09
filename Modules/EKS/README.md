<!-- BEGIN_TF_DOCS -->
## EKS Cluster 

Creates an EKS Cluster with Managed Nodes in Groups and also create addons and fargate profile.

## Prerequisite

- [VPC and subnets are required.](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html)
- [Security group is required.](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html)
- [AWS IAM Roles are required](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html)

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.60.0|
<a name="provider_terraform"></a> [terraform](#provider\_aws) | 1.4.4|
## Resources

| Name | Type |
|------|------|
| [aws_eks_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | Manages an EKS add-on | <pre>list(object({<br>    name                     = string                 # Name of the addons<br>    version                  = string                 # The version of the EKS add-on<br>    resolve_conflicts        = optional(string, null) # Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE<br>    configuration_values     = optional(string, null) # custom configuration values for addons with single JSON string.<br>    preserve                 = optional(bool)         # Indicates if you want to preserve the created resources when deleting the EKS add-on.<br>    service_account_role_arn = optional(string, null) # The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account.<br>    addon_tag_name           = map(string)            # Key-value map of resource tags<br>  }))</pre> | `[]` | no |
| <a name="input_aws_eks_cluster_version"></a> [aws\_eks\_cluster\_version](#input\_aws\_eks\_cluster\_version) | Desired Kubernetes master version | `string` | `null` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | n/a | yes |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the amazon EKS  private API server | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the amazon EKS  public API server | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the amazon Eks public api server endpoint | `list(string)` | null | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluste | `string` | n/a | yes |
| <a name="input_cluster_security_group_ids"></a> [cluster\_security\_group\_ids](#input\_cluster\_security\_group\_ids) | Security group ids | `list(string)` | n/a | yes |
| <a name="input_cluster_subnet_ids"></a> [cluster\_subnet\_ids](#input\_cluster\_subnet\_ids) | List of Subnet ID's for EKS cluster | `list(string)` | n/a | yes |
| <a name="input_eks_cluster_role_arn"></a> [eks\_cluster\_role\_arn](#input\_eks\_cluster\_role\_arn) | ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behal | `string` | n/a | yes |
| <a name="input_eks_cluster_tag_name"></a> [eks\_cluster\_tag\_name](#input\_eks\_cluster\_tag\_name) | Key-value map of resource tags | `map(string)` | n/a | yes |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | Configuration block with encryption configuration for the cluster. Only available on Kubernetes 1.13 and above clusters created after March 6, 2020 | <pre>list(object({<br>    encryption_config_resources = list(string) # List of strings with resources to be encrypted<br>    provider = list(object({<br>      key_arn = string # ARN of the Key Management Service (KMS) customer master key (CMK)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_fargate_profile"></a> [fargate\_profile](#input\_fargate\_profile) | n/a | <pre>map(object({<br>    fargate_profile_name = string #Name of the EKS Fargate Profile.<br>    pod_execution_role_arn = string #Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile.<br>    selector = list(object({  #Configuration block(s) for selecting Kubernetes Pods to execute with this EKS Fargate Profile. Detailed below.<br>      namespace = string #Kubernetes namespace for selection.<br>      labels = optional(map(string),null) #Key-value map of Kubernetes labels for selection.<br>    }))<br>    subnet_ids_fargate = list(string) # Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME (where CLUSTER_NAME is replaced with the name of the EKS Cluster).<br>    tags = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | Configuration block with kubernetes network configuration for the cluster | <pre>list(object({<br>    ip_family         = optional(string) # The IP family used to assign Kubernetes pod and service addresses<br>    service_ipv4_cidr = optional(string) # The CIDR block to assign Kubernetes pod and service IP addresses<br>    service_ipv6_cidr = optional(string) # The CIDR block to assign Kubernetes pod and service IP addresses<br>  }))</pre> | `[]` | no |
| <a name="input_outpost_config"></a> [outpost\_config](#input\_outpost\_config) | Configuration block representing the configuration of your local Amazon EKS cluster on an AWS Outpost | <pre>list(object({<br>    control_plane_instance_type = string # The Amazon EC2 instance type that you want to use for your local Amazon EKS cluster on Outposts<br>    control_plane_placement = optional(list(object({<br>      group_name = string # The name of the placement group for the Kubernetes control plane instances<br>    })), [])<br>    outpost_arns = list(string) # The ARN of the Outpost that you want to use for your local Amazon EKS cluster on Outpost<br>  }))</pre> | `[]` | no |
| <a name="input_worker_node_group"></a> [worker\_node\_group](#input\_worker\_node\_group) | Manages an EKS node group | <pre>list(object({<br>    eks_worker_node_group_name = string                       # Worker node group name<br>    node_role_arn              = string                       # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.<br>    subnet_ids                 = list(string)                 # Identifiers of EC2 Subnets to associate with the EKS Node Group<br>    instance_types             = optional(list(string), null) # List of instance types associated with the EKS Node Group.  <br>    ami_type                   = optional(string, null)       # Type of Amazon Machine Image (AMI) associated with the EKS Node Group<br>    capacity_type              = optional(string, null)       # Type of capacity associated with the EKS Node Group. Valid values( ON_DEMAND, SPOT)<br>    node_group_name_prefix     = optional(string, null)       # Minimum number of aws worker nodes<br>    disk_size                  = optional(number, null)       # Disk size in GiB for worker nodes<br>    force_update_version       = optional(bool, null)         # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.<br>    labels                     = optional(map(string), null)  # Key-value map of Kubernetes labels<br>    release_version            = optional(string, null)       # AMI version of the EKS Node Group<br>    worker_version             = optional(string, null)       # Kubernetes version<br>    remote_access = optional(list(object({<br>      ec2_ssh_key               = optional(string, null) # EC2 Key Pair name that provides access for remote communication with the worker nodes in the EKS Node Group<br>      source_security_group_ids = optional(list(string)) # Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes<br>    })), [])<br>    launch_template = optional(list(object({<br>      id                      = optional(string, null) # Identifier of the EC2 Launch Template <br>      name                    = optional(string, null) # Name of the EC2 Launch Template<br>      launch_template_version = string                 # EC2 Launch Template version number. While the API accepts values like $Default and $Lates<br>    })), [])<br>    desired_size = number # Desired number of aws worker nodes<br>    max_size     = number # Maximum number of aws worker nodes<br>    min_size     = number # Minimum number of aws worker nodes<br>    taint = optional(list(object({<br>      key    = string                 # The key of the taint<br>      value  = optional(string, null) # The value of the taint<br>      effect = string                 # The effect of the taint. Valid values: NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE.<br>    })), [])<br>    eks_worker_node_group_tag_name = map(string) # Key-value map of resource tags<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The ID of your local Amazon EKS cluster on the AWS Outpost |

## Module

```
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

```
<!-- END_TF_DOCS -->