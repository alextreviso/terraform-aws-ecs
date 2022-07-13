resource "aws_ecs_service" "ecs-service" {
  name                               = "${var.app_name}-service"
  cluster                            = aws_ecs_cluster.cluster.name
  task_definition                     = "${aws_ecs_task_definition.task_definition.family}:${aws_ecs_task_definition.task_definition.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  scheduling_strategy                = "REPLICA"
 
  network_configuration {
    security_groups  = [aws_security_group.sg-ecs-task.id]
    subnets          = var.public_subnets_ids
    assign_public_ip = false
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base = 1
    weight = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base = 0
    weight = 4
  }
 
  load_balancer {
    target_group_arn = aws_alb_target_group.tg.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }
 
  lifecycle {
    ignore_changes = [desired_count]
  }
}