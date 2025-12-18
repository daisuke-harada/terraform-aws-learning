# ===================================
# IAM Roles
# 管理者権限ロールを作成
# ===================================

# AssumeRoleポリシードキュメント
# エントリーユーザーがこのロールを引き受けられるように設定
# MFA認証が必須
data "aws_iam_policy_document" "admin_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      # 同じモジュール内のユーザーARNを直接参照
      identifiers = [aws_iam_user.entry_user.arn]
    }

    # MFA認証を必須にする条件
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

# 管理者ロールの作成
resource "aws_iam_role" "admin_role" {
  name               = "switch-role-admin"
  description        = "Switch role for administrators with full access"
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role.json
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

# GitHub Actions用の信頼ポリシードキュメント
# OIDC経由でのAssumeRoleを許可する設定
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    # WebIdentity経由でのロール引き受けを許可
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      # GitHub ActionsのOIDCプロバイダーを信頼する
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # オーディエンス（aud）の検証
    # GitHub ActionsがSTSを呼び出していることを確認
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # サブジェクト（sub）の検証
    # 特定のリポジトリからのアクセスのみを許可
    # ワイルドカード(*)でブランチやタグを問わず許可
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:daisuke-harada/terraform-aws-learning:*"]
    }
  }
}

# GitHub Actions用ロールの作成
resource "aws_iam_role" "github_actions_role" {
  name               = "github-actions-role"
  description        = "Role for GitHub Actions with limited permissions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
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