output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = try(aws_sqs_queue.this[0].id, null)
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = try(aws_sqs_queue.this[0].arn, null)
}

output "queue_url" {
  description = "Same as `queue_id`: The URL for the created Amazon SQS queue"
  value       = try(aws_sqs_queue.this[0].url, null)
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = try(aws_sqs_queue.this[0].name, null)
}

output "dead_letter_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = try(aws_sqs_queue.dead_letter_queue[0].id, null)
}

output "dead_letter_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = try(aws_sqs_queue.dead_letter_queue[0].arn, null)
}

output "dead_letter_queue_url" {
  description = "Same as `dead_letter_queue_id`: The URL for the created Amazon SQS queue"
  value       = try(aws_sqs_queue.dead_letter_queue[0].url, null)
}

output "dead_letter_queue_name" {
  description = "The name of the SQS queue"
  value       = try(aws_sqs_queue.dead_letter_queue[0].name, null)
}
