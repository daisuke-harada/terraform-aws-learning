# ===================================
# Outputs
# ===================================

# 他のモジュールから参照される可能性のある基本情報
output "user_arn" {
  description = "IAMユーザーのARN"
  value       = aws_iam_user.entry_user.arn
}

# 認証情報（機密情報をまとめて管理）
output "credentials" {
  description = "ユーザーの認証情報"
  value = {
    console_password  = aws_iam_user_login_profile.entry_user.password
    access_key_id     = aws_iam_access_key.entry_user.id
    secret_access_key = aws_iam_access_key.entry_user.secret
  }
  sensitive = true
}
