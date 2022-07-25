# Output
output "instance-dns" {
  value = aws_instance.ecnode1.public_dns
}

output "instance-ip" {
  value = aws_instance.ecnode1.public_ip
}

