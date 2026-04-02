variable "default_token_ttl" {
    description = "Default TTL in seconds for an auth token created by Vault to be valid."
    type        = number
    default     = 900 # 15m
}

variable "default_token_max_ttl" {
    description = "Default maximum TTL in seconds for an auth token created by Vault to be valid."
    type        = number
    default     = 1800 # 30m
}