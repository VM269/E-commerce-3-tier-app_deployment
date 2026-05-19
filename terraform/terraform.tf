terraform {
  backend "s3" {
    bucket = "terraform-s3-backend-3-tier-app-391623252926-ap-south-1-an"
    key    = "backend-locking"
    region = "ap-south-1"
    use_lockfile = true
  }
}