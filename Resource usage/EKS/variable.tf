variable "aws_region" {
  description = "Name of region"
  type        = string
}
variable "aws_profile" {
  description = "Name of profile"
  type        = string
}

################################### aws_eks_cluster ########################

variable "cluster_name" {
  description = "Name of the cluste"
  type        = string
}
variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behal"
  type        = string
}
variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}
variable "encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. Only available on Kubernetes 1.13 and above clusters created after March 6, 2020"
  type = list(object({
    encryption_config_resources = list(string) # List of strings with resources to be encrypted
    provider = list(object({
      key_arn = string # ARN of the Key Management Service (KMS) customer master key (CMK)
    }))
  }))
  default = []
}
variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the amazon EKS  public API server"
  type        = bool
}
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the amazon EKS  private API server"
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the amazon Eks public api server endpoint"
  type        = list(string)
  default = null
}
variable "cluster_security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}
variable "cluster_subnet_ids" {
  description = "List of Subnet ID's for EKS cluster"
  type        = list(string)
}
variable "kubernetes_network_config" {
  description = "Configuration block with kubernetes network configuration for the cluster"
  type = list(object({
    ip_family         = optional(string) # The IP family used to assign Kubernetes pod and service addresses
    service_ipv4_cidr = optional(string) # The CIDR block to assign Kubernetes pod and service IP addresses
    service_ipv6_cidr = optional(string) # The CIDR block to assign Kubernetes pod and service IP addresses
  }))
  default = []
}
variable "outpost_config" {
  description = "Configuration block representing the configuration of your local Amazon EKS cluster on an AWS Outpost"
  type = list(object({
    control_plane_instance_type = string # The Amazon EC2 instance type that you want to use for your local Amazon EKS cluster on Outposts
    control_plane_placement = optional(list(object({
      group_name = string # The name of the placement group for the Kubernetes control plane instances
    })), [])
    outpost_arns = list(string) # The ARN of the Outpost that you want to use for your local Amazon EKS cluster on Outpost
  }))
  default = []
}
variable "aws_eks_cluster_version" {
  description = "Desired Kubernetes master version"
  type        = string
  default     = null
}
variable "eks_cluster_tag_name" {
  description = "Key-value map of resource tags"
  type        = map(string)
}

################################ aws_eks_node_group #################################

variable "worker_node_group" {
  description = "Manages an EKS node group"
  type = list(object({
    eks_worker_node_group_name = string                       # Worker node group name
    node_role_arn              = string                       # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
    subnet_ids                 = list(string)                 # Identifiers of EC2 Subnets to associate with the EKS Node Group
    instance_types             = optional(list(string), null) # List of instance types associated with the EKS Node Group.  
    ami_type                   = optional(string, null)       # Type of Amazon Machine Image (AMI) associated with the EKS Node Group
    capacity_type              = optional(string, null)       # Type of capacity associated with the EKS Node Group. Valid values( ON_DEMAND, SPOT)
    node_group_name_prefix     = optional(string, null)       # Minimum number of aws worker nodes
    disk_size                  = optional(number, null)       # Disk size in GiB for worker nodes
    force_update_version       = optional(bool, null)         # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
    labels                     = optional(map(string), null)  # Key-value map of Kubernetes labels
    release_version            = optional(string, null)       # AMI version of the EKS Node Group
    worker_version             = optional(string, null)       # Kubernetes version
    remote_access = optional(list(object({
      ec2_ssh_key               = optional(string, null) # EC2 Key Pair name that provides access for remote communication with the worker nodes in the EKS Node Group
      source_security_group_ids = optional(list(string)) # Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes
    })), [])
    launch_template = optional(list(object({
      id                      = optional(string, null) # Identifier of the EC2 Launch Template 
      name                    = optional(string, null) # Name of the EC2 Launch Template
      launch_template_version = string                 # EC2 Launch Template version number. While the API accepts values like $Default and $Lates
    })), [])
    desired_size = number # Desired number of aws worker nodes
    max_size     = number # Maximum number of aws worker nodes
    min_size     = number # Minimum number of aws worker nodes
    taint = optional(list(object({
      key    = string                 # The key of the taint
      value  = optional(string, null) # The value of the taint
      effect = string                 # The effect of the taint. Valid values: NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE.
    })), [])
    eks_worker_node_group_tag_name = map(string) # Key-value map of resource tags
  }))
  default = []
}
################################ aws_eks_addon #####################################

variable "addons" {
  description = "Manages an EKS add-on"
  type = list(object({
    name                     = string                 # Name of the addons
    version                  = string                 # The version of the EKS add-on
    resolve_conflicts        = optional(string, null) # Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE, OVERWRITE and PRESERVE
    configuration_values     = optional(string, null) # custom configuration values for addons with single JSON string.
    preserve                 = optional(bool)         # Indicates if you want to preserve the created resources when deleting the EKS add-on.
    service_account_role_arn = optional(string, null) # The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account.
    addon_tag_name           = map(string)            # Key-value map of resource tags
  }))
  default = []
}

#####################- AWS EKS FARGATE PROFILE -#############################

variable "fargate_profile" {
  type = map(object({
    fargate_profile_name = string #Name of the EKS Fargate Profile.
    pod_execution_role_arn = string #Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile.
    selector = list(object({  #Configuration block(s) for selecting Kubernetes Pods to execute with this EKS Fargate Profile. Detailed below.
      namespace = string #Kubernetes namespace for selection.
      labels = optional(map(string),null) #Key-value map of Kubernetes labels for selection.
    }))
    subnet_ids_fargate = list(string) # Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
    tags = map(string)
  }))
  default = {}
}


