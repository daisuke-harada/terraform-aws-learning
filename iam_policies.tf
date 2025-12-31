# ===================================
# IAM Policies
# 共通で使用するポリシーを定義
# ===================================

# ===================================
# Identity-based Policies (アイデンティティベースポリシー)
# ユーザー・グループに付与する権限ポリシー
# ===================================

# ポリシードキュメント: ブラウザログイン用
data "aws_iam_policy_document" "browser_login" {
  statement {
    sid    = "AllowBrowserLogin"
    effect = "Allow"
    actions = [
      "signin:AuthorizeOAuth2Access", # OAuth2によるブラウザログインを許可
      "signin:CreateOAuth2Token"      # OAuth2トークンの作成を許可
    ]
    resources = ["*"]
  }
}

# IAMポリシー: ブラウザログイン
resource "aws_iam_policy" "browser_login" {
  name        = "AllowBrowserLogin"
  description = "Allow browser-based AWS SSO login"
  policy      = data.aws_iam_policy_document.browser_login.json
}

# ポリシードキュメント: Adminロールへのスイッチ権限
data "aws_iam_policy_document" "assume_admin_role" {
  statement {
    sid       = "AllowSwitchToAdmin"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.admin_role.arn]
  }
}

# IAMポリシー: Adminロールスイッチ
resource "aws_iam_policy" "assume_admin_role" {
  name        = "AllowAssumeAdminRole"
  description = "Allow switching to admin role"
  policy      = data.aws_iam_policy_document.assume_admin_role.json
}

# ===================================
# Trust Policies (信頼ポリシー)
# ロールに設定するAssumeRole用ポリシー
# ===================================

# 信頼ポリシー: Admin Role用
# entry_userがこのロールにスイッチできるように設定（MFA必須）
data "aws_iam_policy_document" "admin_role_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
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

# 信頼ポリシー: GitHub Actions Role用
# OIDC経由でGitHub Actionsがこのロールを引き受けられるように設定
data "aws_iam_policy_document" "github_actions_role_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # オーディエンス（aud）の検証
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # サブジェクト（sub）の検証
    # 特定のリポジトリからのアクセスのみを許可
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:daisuke-harada/terraform-aws-learning:*"]
    }
  }
}
