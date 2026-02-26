resource "aws_iam_policy" "alb_controller_policy" {
  name   = "devops-aws-load-balancer-controller-policy"
  policy = file("${path.module}/iam_policy.json")
}
module "alb_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "devops-alb-controller-role"

  role_policy_arns = {
    alb = aws_iam_policy.alb_controller_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}