# ===================================
# IAM Users
# 入口ユーザーを作成
# ===================================

# IAMユーザーの作成
# 最小権限の原則に従い、このユーザー自体には権限を付与しない
# 必要に応じてswitch-role-adminロールにスイッチして作業する
resource "aws_iam_user" "entry_user" {
  name = "entry-user"
  path = "/"
}

# コンソールログイン用パスワード
# 初回ログイン時のパスワードリセット要否はvariables.tfで設定可能
resource "aws_iam_user_login_profile" "entry_user" {
  user                    = aws_iam_user.entry_user.name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

# アクセスキー（CLI/API用）
# AWS CLIやTerraformからの操作に使用
# 注意: アクセスキーは慎重に管理すること
resource "aws_iam_access_key" "entry_user" {
  user = aws_iam_user.entry_user.name
}

# entry_userをdevelopersグループに追加
resource "aws_iam_user_group_membership" "entry_user_membership" {
  user = aws_iam_user.entry_user.name
  groups = [
    aws_iam_group.developers.name
  ]
}

# entry_userにAdminロールスイッチ権限をアタッチ
resource "aws_iam_user_policy_attachment" "entry_user_assume_admin" {
  user       = aws_iam_user.entry_user.name
  policy_arn = aws_iam_policy.assume_admin_role.arn
}
