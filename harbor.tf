#harbor
resource "kubernetes_namespace" "harbor-ns" {
  depends_on = [module.aws_eks, null_resource.update_kubeconfig]
  metadata {
    name = var.harbor_namespace
  }
}

resource "null_resource" "deploy-postgres" {
  depends_on = [kubernetes_namespace.harbor-ns]

  provisioner "local-exec" {
    command = "kubectl apply -f values/postgres.yaml --context ${var.eks_context} -n ${var.harbor_namespace}"
  }
}

resource "aws_iam_role_policy_attachment" "harbor_role_attach" {
  role       = aws_iam_role.harbor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_iam_role" "harbor_role" {
  name = "harbor_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::${var.aws_account}:oidc-provider/${module.aws_eks.eks_oidc_provider}"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "${module.aws_eks.eks_oidc_provider}:aud" : "sts.amazonaws.com"
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:${var.harbor_namespace}:harbor-sa"
        }
      }
    }]
  })
}

resource "kubernetes_service_account" "harbor-sa" {
  depends_on    = [kubernetes_namespace.harbor-ns]
  metadata {
    name        = "harbor-sa"
    namespace   = var.harbor_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::705577181377:role/${aws_iam_role.harbor_role.name}"
    }
  }
}

resource "helm_repository" "harbor-repository" {
  name = "harbor-release"
  url  = "https://helm.goharbor.io/"
}


resource "helm_release" "harbor" {
  depends_on       = [kubernetes_namespace.harbor-ns, helm_repository.harbor-repository]
  name             = "harbor"
  chart            = "harbor"
  repository       = "harbor-release"
  namespace        = var.harbor_namespace
  version          = "1.14.2"
  values           = ["${file("values/harbor.yaml")}"]
}