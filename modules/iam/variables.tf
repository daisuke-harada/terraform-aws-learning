# ===================================
# Variables
# IAMモジュールの変数定義
# ===================================

# ユーザー関連
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

# ロール関連
variable "admin_role_name" {
  description = "管理者ロールの名前"
  type        = string
  default     = "admin-role"
}

variable "admin_role_description" {
  description = "管理者ロールの説明"
  type        = string
  default     = "管理者権限を持つIAMロール"
}
