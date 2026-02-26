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

