resource "aws_efs_file_system" "tm_efs" {
  creation_token = var.aws_efs_file_system_name

  tags = {
    Name = "tm-devops-test-efs"
  }
}

# 2. Create EFS Mount Targets in each Public Subnet
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(aws_subnet.public)
  file_system_id  = aws_efs_file_system.tm_efs.id
  subnet_id       = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.efs_mount.id]
}