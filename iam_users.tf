# ===================================
# IAM Users
# 入口ユーザーを作成
# ===================================

# ===================================
# OIDC Provider for GitHub Actions
# GitHub ActionsからAWSリソースへ安全にアクセスするための設定
# ===================================

# GitHub Actions用のOIDCプロバイダー
# アクセスキーを使わずに、GitHub Actionsから一時的な認証情報を取得できる
# これにより、シークレットにアクセスキーを保存する必要がなくなる
resource "aws_iam_openid_connect_provider" "github" {
  # GitHub ActionsのOIDCエンドポイント
  url = "https://token.actions.githubusercontent.com"

  # STSサービスをオーディエンスとして指定
  # これにより、GitHub ActionsがAssumeRoleWithWebIdentityを呼び出せる
  client_id_list = ["sts.amazonaws.com"]

  # OIDCプロバイダーのサーバー証明書の指紋
  # 注意: 本番環境では正しい指紋を設定すること
  thumbprint_list = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
}

# IAMユー���ーの作成
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
