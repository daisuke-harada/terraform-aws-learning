# ===================================
# IAM Groups
# ユーザーグループの定義
# ===================================

# developersグループ
resource "aws_iam_group" "developers" {
  name = "developers-group"
  path = "/"
}

# グループにブラウザログインポリシーをアタッチ
resource "aws_iam_group_policy_attachment" "developers_browser_login" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.browser_login.arn
}
