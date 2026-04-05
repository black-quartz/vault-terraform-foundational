variable "kubernetes_host" {
    description = "Endpoint to use for Kubernetes auth verification."
    type        = string
    default     = "https://kubernetes.default.svc"
}