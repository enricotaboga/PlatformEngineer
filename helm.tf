resource "null_resource" "update_kubeconfig" {
  depends_on = [module.aws_eks]

  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.eks_cluster_name} --alias ${var.eks_context}"
  }
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx" 
  create_namespace = true

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }
  depends_on = [module.aws_eks, kubernetes_namespace.ingress_nginx]
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
