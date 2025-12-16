# ===================================
# IAM Roles
# 管理者権限ロールを作成
# ===================================

# AssumeRoleポリシードキュメント
# エントリーユーザーがこのロールを引き受けられるように設定
data "aws_iam_policy_document" "admin_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      # 同じモジュール内のユーザーARNを直接参照
      identifiers = [aws_iam_user.entry_user.arn]
    }
  }
}

# 管理者ロールの作成
resource "aws_iam_role" "admin_role" {
  name               = var.admin_role_name
  description        = var.admin_role_description
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role.json
}

# 管理者ポリシーをロールにアタッチ
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
