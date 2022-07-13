resource "aws_security_group" "sg-ecs-task" {
    name = "sg_${var.app_name}-task"
    vpc_id = var.vpc_id

    ingress {
        description = "Internal access to API"
        from_port   = var.container_port
        to_port     = var.container_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sg_${var.app_name}-task"
        env = var.env
    }
}

resource "aws_security_group" "sg-alb" {
    name = "sg_alb-${var.app_name}"
    vpc_id = var.vpc_id

    ingress {
        description = "HTTP Access to external IPs"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = var.allowed_cidrs
    }

    ingress {
        description = "HTTPS Access to external IPs"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = var.allowed_cidrs
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sg_alb-${var.app_name}"
        env  = var.env
    }
}