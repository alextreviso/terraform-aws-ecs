resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.app_name
  container_definitions = jsonencode([
    {
      name                     = "${var.app_name}"
      image                    = "${var.repository_url}:latest"
      cpu                      = var.task_cpu
      memory                   = var.task_memory
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/${var.app_name}"
          awslogs-region = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  execution_role_arn       = aws_iam_role.ecs-task-role.arn
  task_role_arn            = aws_iam_role.ecs-task-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  tags = {
    Name        = "${var.app_name}-task"
    environment = var.env
  }
}
