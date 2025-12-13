resource aws_iam_user "entry_user" {
  name = "entry-user"
  path = "/"
}

# コンソールログイン用パスワード
resource "aws_iam_user_login_profile" "entry_user" {
  user                    = aws_iam_user.entry_user.name
  password_length         = 16
  password_reset_required = false
}

# アクセスキー（CLI用）
resource "aws_iam_access_key" "entry_user" {
  user = aws_iam_user.entry_user.name
}

output "entry_user_console_password" {
  value     = aws_iam_user_login_profile.entry_user.password
  sensitive = true
}

output "entry_user_access_key" {
  value     = aws_iam_access_key.entry_user.id
  sensitive = true
}

output "entry_user_secret_key" {
  value     = aws_iam_access_key.entry_user.secret
  sensitive = true
}