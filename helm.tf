resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  chart     = "https://kubernetes.github.io/ingress-nginx"
  namespace = "ingress-nginx"
  version   = "v1.9.6"
}

resource "helm_release" "harbor" {
  name      = "harbor"
  chart     = "https://helm.goharbor.io"
  namespace = "harbor"
  version   = "2.10.0"
}
