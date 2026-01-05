resource "aws_budgets_budget" "cost_alert" {
  name              = "monthly-budget-alert"
  budget_type       = "COST"
  limit_amount      = "30" # 毎月の予算
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2026-01-01_00:00"

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 90 # 予算の90%を超えた場合に通知
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.email]
  }
}