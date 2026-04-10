resource "vault_policy" "cert_manager" {
    name = "platform-cert-manager-kubernetes_auth"

    policy = <<EOT
        path "pki/sign/kubernetes" {
          capabilities = ["create", "update"]
        }

        path "pki/issue/kubernetes" {
          capabilities = ["create", "update"]
        }

        path "pki/sign/gateway" {
          capabilities = ["create", "update"]
        }

        path "pki/issue/gateway" {
          capabilities = ["create", "update"]
        }

        path "pki/ca_chain" {
          capabilities = ["read"]
        }
    EOT
}

resource "vault_kubernetes_auth_backend_role" "cert_manager" {
    backend                          = vault_auth_backend.kubernetes.path

    role_name                        = "cert-manager"
    token_policies                   = [vault_policy.cert_manager.name]
    token_ttl                        = 3600

    bound_service_account_names      = ["cert-manager"]
    bound_service_account_namespaces = ["cert-manager"]
}