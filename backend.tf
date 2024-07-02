terraform {
  backend "s3" {
    bucket         = "tf-backend-turtle"
    key            = "eks/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
