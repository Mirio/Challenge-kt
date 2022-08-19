terraform {
  backend "s3" {
    bucket = "<INSERT BUCKET NAME>"
    key    = "challenge-kt/state.tf"
    region = "eu-central-1"
  }
}
