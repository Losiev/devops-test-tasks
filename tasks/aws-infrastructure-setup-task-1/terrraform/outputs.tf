output "alb_dns_name" {
  description = "DNS-ім'я ALB"
  value       = aws_lb.tm_alb.dns_name
}

output "ec2_instance_public_ip" {
  description = "Публічна IP-адреса EC2-воркера"
  value       = aws_instance.ecs_worker_node.public_ip
}
