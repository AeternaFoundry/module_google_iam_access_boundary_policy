resource "google_iam_access_boundary_policy" "iam_access_boundary_policies" {
  for_each = var.iam_access_boundary_policies

  name            = each.value.name
  parent          = each.value.parent
  deletion_policy = each.value.deletion_policy
  display_name    = each.value.display_name

  dynamic "rules" {
    for_each = each.value.rules
    content {
      dynamic "access_boundary_rule" {
        for_each = rules.value.access_boundary_rule != null ? [rules.value.access_boundary_rule] : []
        content {
          dynamic "availability_condition" {
            for_each = access_boundary_rule.value.availability_condition != null ? [access_boundary_rule.value.availability_condition] : []
            content {
              description = availability_condition.value.description
              expression  = availability_condition.value.expression
              location    = availability_condition.value.location
              title       = availability_condition.value.title
            }
          }
          available_permissions = access_boundary_rule.value.available_permissions
          available_resource    = access_boundary_rule.value.available_resource
        }
      }
      description = rules.value.description
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

