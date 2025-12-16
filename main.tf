# Terraform設定ブロック
# 使用するプロバイダーとTerraformのバージョン要件を定義
terraform {
  required_providers {
    # AWS Providerの設定
    aws = {
      source = "hashicorp/aws"
      # AWS Provider バージョン 5.x系の最新を使用
      version = "~> 5.80"
    }
  }

  # Terraformのバージョン要件
  required_version = ">= 1.10.0"
}

# AWSプロバイダーの設定
# デフォルトリージョンを東京(ap-northeast-1)に設定
provider "aws" {
  region = "ap-northeast-1"
}

# ===================================
# Modules
# ===================================

# IAM Users
module "iam_users" {
  source = "./modules/iam/users"

  # 変数をモジュールに渡す
  entry_user_name         = var.entry_user_name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

# IAM Roles
module "iam_roles" {
  source = "./modules/iam/roles"

  # 変数をモジュールに渡す
  admin_role_name        = var.admin_role_name
  admin_role_description = var.admin_role_description
  admin_policy_arn       = var.admin_policy_arn
}
