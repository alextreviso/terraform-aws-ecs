output "alb_listener_arn" {
    value = aws_alb_listener.http.arn
}

output "sg_alb_id" {
    value = aws_security_group.sg-alb.id  
}