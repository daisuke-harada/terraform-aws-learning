# ===================================
# IAM Roles
# 管理者権限ロールを作成
# ===================================

# 管理者ロールの作成
resource "aws_iam_role" "admin_role" {
  name               = "switch-role-admin"
  description        = "Switch role for administrators with full access"
  assume_role_policy = data.aws_iam_policy_document.admin_role_trust.json
}

# 管理者ポリシーをロールにアタッチ
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ===================================
# IAM Role for GitHub Actions
# GitHub ActionsからOIDC経由でアクセスするためのロール
# ===================================

# GitHub Actions用ロールの作成
resource "aws_iam_role" "github_actions_role" {
  name               = "github-actions-role"
  description        = "Role for GitHub Actions with limited permissions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_role_trust.json
}

# GitHub Actionsロールに権限ポリシーをアタッチ
# 注意: 本番環境では必要最小限の権限に絞ること
resource "aws_iam_role_policy_attachment" "github_actions_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# GitHub ActionsのワークフローファイルでこのARNを使用する
output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}