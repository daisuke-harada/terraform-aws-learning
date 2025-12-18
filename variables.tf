# ===================================
# Variables
# ===================================

variable "password_length" {
  description = "Length of the console login password"
  type        = number
  default     = 16
}

variable "password_reset_required" {
  description = "Whether to require password reset on first login"
  type        = bool
  default     = false
}
