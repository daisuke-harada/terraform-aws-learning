# ===================================
# Outputs
# ===================================

# 他のモジュールから参照される最も重要な情報
output "role_arn" {
  description = "IAMロールのARN"
  value       = aws_iam_role.admin_role.arn
}
