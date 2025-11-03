terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "smachno-terraform-state-bucket" # Назва вашого S3-бакету
    key            = "global/eks/terraform.tfstate"   # Шлях до файлу стану всередині бакету
    region         = "eu-central-1"                   # Регіон, де знаходиться бакет
    dynamodb_table = "terraform-state-lock"           # Таблиця для блокування
  }
}

provider "aws" {
  region = "eu-central-1"
}