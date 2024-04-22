#ingress-controller
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

  set {
    name  = "controller.service.internal.nodePorts.http"
    value = "30080"
  }

  depends_on = [module.aws_eks]
}

#efs csi driver
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

#alb controller driver
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "Policy for EKS ALB Controller"
  policy = file("${path.module}/json_files/albControllerPolicy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller_role_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

resource "aws_iam_role" "alb_controller_role" {
  name = "alb_controller_role"

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
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:kube-system:alb_controller_sa"
        }
      }
    }]
  })
}

resource "kubernetes_service_account" "alb_controller_sa" {
  depends_on = [module.aws_eks]
  metadata {
    name      = "alb-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account}:role/${aws_iam_role.alb_controller_role.name}"
    }
  }
}

resource "helm_release" "alb-controller" {
 name       = "aws-load-balancer-controller"
 repository = "https://aws.github.io/eks-charts"
 chart      = "aws-load-balancer-controller"
 namespace  = "kube-system"
 depends_on = [kubernetes_service_account.alb_controller_sa]

 set {
     name  = "region"
     value = var.aws_region
 }

 set {
     name  = "vpcId"
     value = module.aws_vpc.vpc_id
 }

 set {
     name  = "serviceAccount.create"
     value = "false"
 }

 set {
     name  = "serviceAccount.name"
     value = "alb-controller-sa"
 }

 set {
     name  = "clusterName"
     value = var.eks_cluster_name
 }
 }