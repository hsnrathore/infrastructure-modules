output "vpc_id" {
  value = aws_vpc.main.id
}
output "aws_public_subnets" {
  value = aws_subnet.public[*].id
}
output "aws_private_subnets" {
  value = aws_subnet.private[*].id
}
