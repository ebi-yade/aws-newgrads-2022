provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.16.0"
    }
  }
}
