variable "environment" {
  type        = string
  description = "The resource's environment"
}

variable "application" {
  type        = string
  description = "The application that owns the resource"
}

variable "team" {
  type        = string
  description = "The squad that owns the resource"
}

variable "name" {
  type        = string
  description = "The name of the resource"
}

variable "additional_tags" {
  type        = map(any)
  default     = {}
  description = "A map containing additional tags"
}

variable "create_bucket" {
  description = "Controls if S3 bucket should be created"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}
