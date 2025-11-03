#!/bin/bash
# 1. Install EFS Utilities
yum install -y amazon-efs-utils python3-botocore

# 2. Set variables (Passed from Terraform)
EFS_ID="${efs_id}"
MOUNT_PATH="${efs_mount_path}"
CLUSTER_NAME="${cluster_name}"

# 3. Create mount directory
mkdir -p $MOUNT_PATH

# 4. Mount EFS (вперше)
mount -t efs -o tls $EFS_ID:/ $MOUNT_PATH

# --- ВИПРАВЛЕННЯ 2: Робимо монтування постійним (після перезавантажень) ---
# 4.5. Додаємо запис у /etc/fstab
echo "$EFS_ID:/ $MOUNT_PATH efs _netdev,tls 0 0" >> /etc/fstab
# --- Кінець виправлення ---

# 5. Configure ECS Cluster registration
echo "ECS_CLUSTER=$CLUSTER_NAME" >> /etc/ecs/ecs.config

# 6. Start ECS Agent
systemctl enable --now ecs