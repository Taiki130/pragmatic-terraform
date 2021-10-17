resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name              = "/ecs_scheduled-tasks/example"
  retention_in_days = 180
}