# ===================================
# Variables
# ===================================

variable "entry_user_name" {
  description = "入口ユーザーのユーザー名"
  type        = string
  default     = "entry-user"
}

variable "password_length" {
  description = "コンソールログイン用パスワードの長さ"
  type        = number
  default     = 16
}

variable "password_reset_required" {
  description = "初回ログイン時にパスワード変更を要求するか"
  type        = bool
  default     = false
}
