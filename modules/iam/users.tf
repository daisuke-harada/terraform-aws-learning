# ===================================
# IAM Users
# 入口ユーザーを作成
# ===================================

# IAMユーザーの作成
resource "aws_iam_user" "entry_user" {
  name = var.entry_user_name
  path = "/"
}

# コンソールログイン用パスワード
resource "aws_iam_user_login_profile" "entry_user" {
  user                    = aws_iam_user.entry_user.name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

# アクセスキー（CLI用）
resource "aws_iam_access_key" "entry_user" {
  user = aws_iam_user.entry_user.name
}
