resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "service-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-container-${var.environment}"
      image     = "${var.container_image}:latest"
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 80
        }
      ]
      logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = "us-east-1"
                    awslogs-group = aws_cloudwatch_log_group.ecslogs.arn
                    awslogs-stream-prefix = var.environment
                }
            }
    }
  ])
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "ecslogs" {
  name = "stream-to-log-ecs-${var.environment}"

  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

resource "aws_ecs_service" "main" {
  name                               = "${var.app_name}-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = formatlist(aws_security_group.ecs_tasks.id)
    subnets          = var.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.app_name}-container-${var.environment}"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}


resource "aws_security_group" "ecs_tasks" {
  name   = "${var.app_name}-sg-task-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = var.container_port
    to_port          = var.container_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}