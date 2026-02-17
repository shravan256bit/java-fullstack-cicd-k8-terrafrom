output "rds_endpoint" {
  value = aws_db_instance.auth_db.endpoint
}

output "rds_db_name" {
  value = aws_db_instance.auth_db.db_name
}
