resource "vault_audit" "stdout" {
    type        = "file"
    path        = "stdout"
    description = "Kubernetes Log Collection"

    options = {
      file_path = "/dev/stdout"
      format    = "json"
    }
}