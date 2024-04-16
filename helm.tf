resource "null_resource" "update_kubeconfig" {
  depends_on = [module.aws_eks]

  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.eks_cluster_name} --alias ${var.eks_context}"
  }
}

#ingress

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

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

#harbor

resource "kubernetes_namespace" "harbor-ns" {
  depends_on = [module.aws_eks, null_resource.update_kubeconfig]
  metadata {
    name = "harbor"
  }
}

resource "null_resource" "deploy-postgres" {
  depends_on = [kubernetes_namespace.harbor-ns]

  provisioner "local-exec" {
    command = "kubectl apply -f values/postgres.yaml --context ${var.eks_context} -n harbor"
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
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:harbor:harbor-sa"
        }
      }
    }]
  })
}

resource "kubernetes_service_account" "harbor-sa" {
  depends_on    = [kubernetes_namespace.harbor-ns]
  metadata {
    name        = "harbor-sa"
    namespace   = "harbor"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::705577181377:role/${aws_iam_role.harbor_role.name}"
    }
  }
}

resource "helm_release" "harbor" {
  depends_on       = [kubernetes_namespace.harbor-ns]
  name             = "harbor"
  chart            = "harbor"
  repository       = "harbor-release"
  namespace        = "harbor"
  version          = "1.14.2"
  values           = ["${file("values/harbor.yaml")}"]
}

#efs driver

resource "helm_release" "aws_efs_csi_driver" {
  depends_on = [module.aws_eks, aws_iam_role.efs_driver_role]
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  name       = "aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  values     = ["${file("values/efs-driver.yaml")}"]

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${var.aws_account}:role/efs_driver_role"
  }
  set {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = module.aws_efs.efs_id
  }
}

resource "aws_iam_role_policy_attachment" "efs_driver_role_attach" {
  role       = aws_iam_role.efs_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_iam_role" "efs_driver_role" {
  name = "efs_driver_role"

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
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }]
  })
}