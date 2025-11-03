# Get the latest ECS-optimized AMI ID for Amazon Linux 2
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# 1. ECS Cluster
resource "aws_ecs_cluster" "tm_cluster" {
  name = var.aws_ecs_cluster_name
}

resource "aws_instance" "ecs_worker_node" {
  ami           = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public[0].id

  key_name      = "key-for-mate-task"

  vpc_security_group_ids = [aws_security_group.ecs_instance.id]

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name

  user_data = base64encode(templatefile("${path.module}/mount_efs_userdata.sh", {
    cluster_name   = aws_ecs_cluster.tm_cluster.name
    efs_id         = aws_efs_file_system.tm_efs.id
    efs_mount_path = "/mnt/efs-data"
  }))

  depends_on = [
    aws_efs_mount_target.efs_mount_target
  ]

  tags = {
    Name = "tm-ecs-worker-node"
  }
}

# --- ECS Task Definition and Service ---

# 4. Task Definition
resource "aws_ecs_task_definition" "nginx_task" {
  family = "tm-nginx-efs-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  # --- підключення EFS ---
  volume {
    name      = "efs-volume"
    host_path = "/mnt/efs-data"
  }

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }]

      mountPoints = [{
        sourceVolume  = "efs-volume"
        containerPath = "/usr/share/nginx/html"
      }]
    }
  ])
}

# 5. ECS Service (Запуск та підтримка Task Definition)
resource "aws_ecs_service" "nginx_service" {
  name            = "tm-devops-test-service"
  cluster         = aws_ecs_cluster.tm_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  # З'єднуємо сервіс з нашим ALB Target Group
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_instance.ecs_worker_node,
  ]
}

