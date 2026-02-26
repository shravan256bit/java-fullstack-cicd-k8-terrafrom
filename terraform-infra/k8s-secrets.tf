resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = "default"
  }

  data = {
    SPRING_DATASOURCE_URL      = "jdbc:mysql://${aws_db_instance.auth_db.address}:3306/authdb"
    SPRING_DATASOURCE_USERNAME = "admin"
    SPRING_DATASOURCE_PASSWORD = var.db_password
  }

  type = "Opaque"

  depends_on = [module.eks]
}