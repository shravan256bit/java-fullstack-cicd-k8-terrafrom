variable "region" {
  description = "AWS region"
  type        = string
}
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
