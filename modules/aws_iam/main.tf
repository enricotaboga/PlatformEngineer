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
  count              = var.create_iam_role ? 1 : 0
  name = var.iam_role_name
  assume_role_policy = var.assume_role_policy != "" ? var.assume_role_policy : local.default_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_iam_role_policy_attachment ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = var.iam_policy_arn != "" ? var.iam_policy_arn : aws_iam_policy.this[0].arn
}

resource "aws_iam_policy" "this" {
  count       = var.create_iam_policy ? 1 : 0
  name        = var.iam_policy_name
  path        = var.iam_policy_path
  description = var.iam_policy_description
  policy = var.iam_policy_content
}