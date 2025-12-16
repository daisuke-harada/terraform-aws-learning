# ===================================
# Variables - IAM Users
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

# ===================================
# Variables - IAM Roles
# ===================================

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

variable "admin_policy_arn" {
  description = "アタッチする管理者ポリシーのARN"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}
