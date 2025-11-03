# 1. Security Group for ALB (Application Load Balancer)
resource "aws_security_group" "alb" {
  name        = var.aws_security_group_alb_name
  description = "Allow HTTP access from the internet to the ALB"
  vpc_id      = aws_vpc.main.id

  # Ingress: Allow HTTP (Port 80) traffic from the Internet
  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==== 2. Security Group for ECS EC2 Instances ====
resource "aws_security_group" "ecs_instance" {
  name        = var.aws_security_group_ecs_instance_name
  description = "Allow HTTP from ALB and NFS to EFS"
  vpc_id      = aws_vpc.main.id

  # Ingress 1: Allow HTTP (Port 80) traffic ONLY from the ALB SG
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Ingress 2: Allow NFS (Port 2049) traffic from self (used for EFS mount traffic source)
  ingress {
    description = "NFS to EFS Mount Targets"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }
  # Ingress 2: Allow SSH
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Для безпеки можна замінити це на свою локальну IP-адресу
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic (needed for Docker pull, EFS, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Security Group for EFS Mount Targets
resource "aws_security_group" "efs_mount" {
  name        = var.aws_security_group_efs_mount_name
  description = "Allow NFS access from ECS instances"
  vpc_id      = aws_vpc.main.id

  # Ingress: Allow NFS (Port 2049) traffic ONLY from the ECS Instance SG
  ingress {
    description     = "NFS traffic from ECS Instances"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_instance.id]
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
