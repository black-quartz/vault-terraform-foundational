variable "name" {
    description = "Name of the Vault tenant."
    type        = string
    nullable    = false
}

variable "github_auth_backend" {
    description = "Parameters for the GitHub JWT auth backend."
    type = object({
        enabled      = optional(bool, true)
        bound_claims = map(string)
        token_ttl     = optional(number, 900)  # 15m
        token_max_ttl = optional(number, 1800) # 30m
    })
    default = null
}

variable "kubernetes_auth_backend" {
    description = "Parameters for the Kubernetes auth backend."
    type = object({
        enabled                          = optional(bool, true)
        bound_service_account_names      = set(string)
        bound_service_account_namespaces = set(string)
        token_ttl                        = optional(number, 28800) # 8hr
        token_max_ttl                    = optional(number, 86400) # 24hr                      
    })
    default = null
}

variable "kubernetes_secrets_engine" {
    description = "Parameters for the Kubernetes secrets engine."
    type = object({
        enabled                       = optional(bool, true)
        name                          = string
        kubernetes_role_name          = string
        kubernetes_role_type          = string
        allowed_kubernetes_namespaces = list(string)
        token_default_ttl             = optional(number, 900)  # 15m
        token_max_ttl                 = optional(number, 1800) # 30m
    })
    default = null
}

variable "kv_secrets_engine" {
    description = "Parameters for the KV secrets engine."
    type = object({
        enabled = optional(bool, true)
        path    = string
    })
    default = null
}

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
    default     = "kv"
}
