output "bucket_name" {
  description = "ID of S3 Bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn

}
