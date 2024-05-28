output "id" {
  value       = aws_s3_bucket.this[0].id
  description = "The name of the bucket."
}

output "arn" {
  value       = aws_s3_bucket.this[0].arn
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this[0].bucket_domain_name
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
}
