# ===================================
# IAM Roles モジュール
# 管理者ロールを作成
# ===================================

# 現在のAWSアカウント情報を取得
data "aws_caller_identity" "current" {}

# AssumeRoleポリシードキュメント
data "aws_iam_policy_document" "admin_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS" # AWSのユーザー、ロール、アカウント自体などを指定
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAMロールの作成
resource "aws_iam_role" "admin_role" {
  name               = var.admin_role_name
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role_policy.json
  description        = var.admin_role_description
}

# ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = var.admin_policy_arn
}
