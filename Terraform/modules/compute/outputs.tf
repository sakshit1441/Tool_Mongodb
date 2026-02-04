

# Bastion (public instance)
---------------------------
output "public01_id" {
  value = aws_instance.bastion.id
}

# private instances
----------------------------
output "private01_vm_id" {
  value = aws_instance.mongodb_01.id
}

output "private02_vm_id" {
  value = aws_instance.mongodb_02.id
}

# target group 
--------------------------------------
output "Target_group_arn" {
  value = aws_lb_target_group.mongo_tg.arn
}

# ALB 
-----------------------------------------------
output "ALB_arn" {
  value = aws_lb.mongo_alb.arn
}

