resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx" # Certifique-se de que este namespace já existe ou é criado em outro lugar no seu Terraform

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
  depends_on = [module.aws_eks]
}

#resource "helm_release" "harbor" {
#  name       = "harbor"
#  chart      = "harbor"
#  repository = "https://helm.goharbor.io"
#  namespace  = "harbor"
#  version    = "2.10.0"
#}
#
resource "helm_release" "aws_efs_csi_driver" {
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  name       = "aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
}
