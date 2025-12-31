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
