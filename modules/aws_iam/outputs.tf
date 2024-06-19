output "iam_role_name" {
  description = "The name of the role."
  value       = aws_iam_role.this[0].name
}
