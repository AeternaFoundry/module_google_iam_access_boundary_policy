variable "iam_access_boundary_policies" {
  description = <<EOT
Map of iam_access_boundary_policies, attributes below
Required:
    - name
    - parent
    - rules (block):
        - access_boundary_rule (optional, block):
            - availability_condition (optional, block):
                - description (optional)
                - expression (required)
                - location (optional)
                - title (optional)
            - available_permissions (optional)
            - available_resource (optional)
        - description (optional)
Optional:
    - deletion_policy
    - display_name
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    name            = string
    parent          = string
    deletion_policy = optional(string)
    display_name    = optional(string)
    rules = list(object({
      access_boundary_rule = optional(object({
        availability_condition = optional(object({
          description = optional(string)
          expression  = string
          location    = optional(string)
          title       = optional(string)
        }))
        available_permissions = optional(list(string))
        available_resource    = optional(string)
      }))
      description = optional(string)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.iam_access_boundary_policies : (
        length(v.rules) >= 1
      )
    ])
    error_message = "Each rules list must contain at least 1 items"
  }
}

