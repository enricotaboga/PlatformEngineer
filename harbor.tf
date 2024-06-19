#harbor
resource "kubernetes_namespace" "harbor_ns" {
  depends_on = [module.aws_eks, null_resource.update_kubeconfig]
  metadata {
    name = var.harbor_namespace
  }
}

resource "null_resource" "deploy_postgres" {
  depends_on = [kubernetes_namespace.harbor_ns]

  provisioner "local-exec" {
    command = "kubectl apply -f values/postgres.yaml --context ${var.eks_context} -n ${var.harbor_namespace}"
  }
}

module "harbor_iam" {
  source = "./modules/aws_iam"
  create_iam_policy = false
  aws_account = var.aws_account
  eks_oidc_provider = module.aws_eks.eks_oidc_provider
  kubernetes_ns = var.harbor_namespace
  kubernetes_sa = "harbor-sa"
  iam_role_name = "harbor_role"
  iam_policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "kubernetes_service_account" "harbor_sa" {
  depends_on = [kubernetes_namespace.harbor_ns]
  metadata {
    name      = "harbor-sa"
    namespace = var.harbor_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account}:role/${module.harbor_iam.iam_role_name}"
    }
  }
}

resource "null_resource" "helm_add_repo_harbor" {
  provisioner "local-exec" {
    command = "helm repo remove harbor-release > /dev/null && helm repo add harbor-release https://helm.goharbor.io > /dev/null"
  }
}

module "harbor" {
  source     = "./modules/helm"
  depends_on = [kubernetes_namespace.harbor_ns, null_resource.helm_add_repo_harbor, module.alb_controller]
  name       = "harbor"
  chart      = "harbor"
  repository = "harbor-release"
  namespace  = var.harbor_namespace
  helm_version  = "1.14.2"
  values     = ["${file("values/harbor.yaml")}"]
}

resource "null_resource" "ingress_harbor" {
  depends_on = [kubernetes_namespace.harbor_ns]
  provisioner "local-exec" {
    command = "kubectl apply -f values/harbor-ingress.yaml --context ${var.eks_context} -n ${var.harbor_namespace}"
  }
}