# ===================================
# Variables
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
