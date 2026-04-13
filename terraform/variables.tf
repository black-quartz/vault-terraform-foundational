variable "github_auth_backend_path" {
    description = "Path for the GitHub JWT auth backend."
    type        = string
    default     = "jwt"
}

variable "kubernetes_auth_backend_path" {
    description = "Path for the Kubernetes auth backend."
    type        = string
    default     = "kubernetes"
}

variable "kubernetes_secrets_engine_path" {
    description = "Path for the Kubernetes secrets engine."
    type        = string
    default     = "kubernetes"
}

variable "kv_secrets_engine_path" {
    description = "Path for the KV v2 secrets engine."
    type        = string
    default     = "secrets"
}

variable "pki_secrets_engine_path" {
    description = "Path for the PKI secrets engine."
    type        = string
    default     = "pki"
}

variable "kubernetes_host" {
    description = "Endpoint to use for Kubernetes auth verification."
    type        = string
    default     = "https://kubernetes.default.svc"
}