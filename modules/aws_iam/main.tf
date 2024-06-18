locals {
  default_assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::${var.aws_account}:oidc-provider/${var.eks_oidc_provider}"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "${var.eks_oidc_provider}:aud" : "sts.amazonaws.com",
          "${var.eks_oidc_provider}:sub" : "system:serviceaccount:${var.kubernetes_ns}:${var.kubernetes_sa}"
        }
      }
    }]
  })
}

resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = var.assume_role_policy != "" ? var.assume_role_policy : local.default_assume_role_policy

resource "aws_iam_role_policy_attachment" "this" {
  role       = var.iam_role_name
  policy_arn = var.iam_policy_arn
}

resource "aws_iam_policy" "this" {
  name        = var.iam_policy_name
  path        = var.iam_policy_path
  description = var.iam_policy_description
  policy = var.iam_policy_content
}