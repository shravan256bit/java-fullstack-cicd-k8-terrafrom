module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "devops-eks-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_groups = {
  default = {
    instance_types = ["c7i-flex.large"]

    capacity_type  = "ON_DEMAND"

    min_size       = 1
    max_size       = 2
    desired_size   = 1
    }
  } 

  access_entries = {
  root_access = {
    principal_arn = "arn:aws:iam::367283415495:root"

    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
  }
}