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

  backend "s3" {
    bucket  = "daisuke-terraform-state-bucket"
    key     = "terraform-aws-learning/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

# AWSプロバイダーの設定
# デフォルトリージョンを東京(ap-northeast-1)に設定
provider "aws" {
  region = "ap-northeast-1"
}

# ===================================
# 現在のAWSアカウント情報を取得
# ===================================
data "aws_caller_identity" "current" {}
