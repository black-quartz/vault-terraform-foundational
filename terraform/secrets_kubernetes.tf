##################################
### Kubernetes Secrets Backend ###
##################################

resource "vault_kubernetes_secret_backend" "kubernetes" {
    path                 = "kubernetes"
    kubernetes_host      = "https://kubernetes.default.svc"
    disable_local_ca_jwt = false
}
