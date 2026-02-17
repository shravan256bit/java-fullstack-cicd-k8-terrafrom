

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"
  
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# 👇 Separate block
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "devops-eks-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


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
resource "aws_security_group" "rds_sg" {
  name        = "devops-rds-sg"
  description = "Allow MySQL access from EKS nodes"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "devops-rds-sg"
  }
}
resource "aws_security_group_rule" "allow_eks_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = module.eks.node_security_group_id
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "devops-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "devops-rds-subnet-group"
  }
}
resource "aws_db_instance" "auth_db" {
  identifier              = "auth-db"
  engine                  = "mysql"
  engine_version           = "8.0"
  auto_minor_version_upgrade = true
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp3"
  storage_encrypted       = true

  db_name  = "authdb"
  username = "admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible       = false
  backup_retention_period   = 0
  deletion_protection       = false
  skip_final_snapshot       = true

  tags = {
    Name = "auth-db"
  }
}

