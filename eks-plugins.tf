#ingress-controller
module "ingress_nginx" {
  source           = "./modules/helm"
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set_values = [
    {
      name  = "controller.replicaCount"
      value = "1"
    },
    {
      name  = "controller.service.type"
      value = "ClusterIP"
    },
    {
      name  = "controller.service.internal.nodePorts.http"
      value = "30080"
    },
  ]

  depends_on = [module.aws_eks]
}


#efs csi driver
module "aws_efs_csi_driver" {
  source           = "./modules/helm"
  depends_on = [module.aws_eks, aws_iam_role.efs_driver_role]
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  name       = "aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  values     = ["${file("values/efs-driver.yaml")}"]

  set_values = [
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = "arn:aws:iam::${var.aws_account}:role/efs_driver_role"
    },
    {
    name  = "storageClasses[0].parameters.fileSystemId"
    value = module.aws_efs.efs_id
    }
  ]
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

#external DNS
resource "aws_iam_policy" "external_DNS_policy" {
  name        = "AllowExternalDNSUpdates"
  path        = "/"
  description = "Policy for external DNS"
  policy = file("${path.module}/json_files/externalDNSPolicy.json")
}

resource "kubernetes_service_account" "external_DNS_sa" {
  depends_on = [module.aws_eks, null_resource.update_kubeconfig]
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account}:role/${aws_iam_role.external_DNS_role.name}"
    }
  }
}

resource "aws_iam_role" "external_DNS_role" {
  name = "external_DNS_role"

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
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:kube-system:external-dns"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "external_DNS_role_attach" {
  role       = aws_iam_role.external_DNS_role.name
  policy_arn = aws_iam_policy.external_DNS_policy.arn
}

resource "null_resource" "deploy_external_DNS" {
  depends_on = [module.aws_eks]

  provisioner "local-exec" {
    command = <<EOT
kubectl apply -f values/external-dns.yaml --context ${var.eks_context} -n kube-system && kubectl patch deployment external-dns -n kube-system -p '{"spec": {"template": {"spec": {"containers": [{"name": "external-dns", "args": ["--source=service", "--source=ingress", "--provider=aws", "--registry=txt", "--txt-owner-id=${data.aws_route53_zone.selected.zone_id}"]}]}}}}'
    EOT
  }
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
          "${module.aws_eks.eks_oidc_provider}:sub" : "system:serviceaccount:kube-system:alb-controller-sa"
        }
      }
    }]
  })
}

resource "kubernetes_service_account" "alb_controller_sa" {
  depends_on = [module.aws_eks, null_resource.update_kubeconfig]
  metadata {
    name      = "alb-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account}:role/${aws_iam_role.alb_controller_role.name}"
    }
  }
}

module "alb_controller" {
 source     = "./modules/helm"
 name       = "aws-load-balancer-controller"
 repository = "https://aws.github.io/eks-charts"
 chart      = "aws-load-balancer-controller"
 namespace  = "kube-system"
 depends_on = [kubernetes_service_account.alb_controller_sa]
 set_values = [
 {
     name  = "region"
     value = var.aws_region
 },
 {
     name  = "vpcId"
     value = module.aws_vpc.vpc_id
 },
 {
     name  = "serviceAccount.create"
     value = "false"
 },
 {
     name  = "serviceAccount.name"
     value = "alb-controller-sa"
 },
 {
     name  = "clusterName"
     value = var.eks_cluster_name
 }
 ]
 }

 resource "aws_security_group" "ingress_sg" {
  name        = "nlb-ingress-sg"
  description = "Security group for NLB Ingress"
  vpc_id      = module.aws_vpc.vpc_id

  # Ingress and egress rules can be specified here as needed
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.nlb_sg_ipv4_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-ingress"
  }
}

 resource "kubernetes_ingress_v1" "nlb_ingress_https_global" {
  depends_on = [module.alb_controller, module.ingress_nginx]
  metadata {
    name        = "nlb-ingress-https-global"
    namespace   = "ingress-nginx"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/load-balancer-type" = "nlb"
      "alb.ingress.kubernetes.io/certificate-arn"    =  "${module.aws_acm.acm_arn}"
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/security-groups"    = aws_security_group.ingress_sg.id
      "alb.ingress.kubernetes.io/subnets"           = join(",", module.aws_vpc.public_subnets)
      "alb.ingress.kubernetes.io/healthcheck-path"  = "/healthz"
      "alb.ingress.kubernetes.io/healthcheck-port"  = "10254"
      "external-dns.alpha.kubernetes.io/hostname"   = "*.${var.domain}"



    }
  }
  spec {
    ingress_class_name = "alb"

    rule {
      host = "*.${var.domain}"

      http {
        path {
          path        = "/"
          path_type   = "Prefix"

          backend {
            service {
              name = "ingress-nginx-controller"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}