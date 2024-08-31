terraform {
  backend "s3" {
    bucket         = "week10-asm-terraform"
    key            = "week102/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "State-Log"
  }
}
