variable "aws_security_group_alb_name" {
  type        = string
  description = "Name SG for ALB"
  default = "tm-devops-test-alb-sg"
}

variable "aws_security_group_ecs_instance_name" {
  type        = string
  description = "Name SG for ecs instance"
  default = "tm-devops-test-ecs-instance-sg"
}

variable "aws_security_group_efs_mount_name" {
  type        = string
  description = "Name SG for ecs instance"
  default = "tm-devops-test-efs-mount-sg"
}

variable "aws_efs_file_system_name" {
  type        = string
  description = "Name for EFS"
  default = "tm-devops-test-efs"
}

variable "aws_iam_ecs_instance_role_name" {
  type        = string
  description = "Name IAM role for ecs instance"
  default = "tm-ecs-instance-role"
}

variable "aws_iam_instance_profile_name" {
  type        = string
  description = "Name IAM instance profile for ecs instance"
  default = "tm-ecs-instance-profile"
}

variable "aws_ecs_cluster_name" {
  type        = string
  description = "Name ECS cluster"
  default = "tm-devops-test-cluster"
}

variable "aws_lb_name" {
  type        = string
  description = "Name ALB"
  default = "tm-devops-test-alb"
}

variable "aws_lb_target_group_name" {
  type        = string
  description = "Name ALB target group"
  default = "tm-nginx-tg"
}

