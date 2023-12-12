resource "abbey_grant_kit" "aws_iam_admin_group" {
    name = "aws_iam_admin_group"
    description = <<-EOT
        adds user to the IAM Admin group
    EOT

    workflow = {
        steps = [
            {
                reviewers = {
                    one_of = ["john.doe@abbey.io"]
                }
            }
        ]
    }

    policies = [
        {
        query = <<-EOT
        package main

        import data.abbey.functions

        allow[msg] {
            functions.expire_after("24h")
            msg := "revoking access after 24 hours."
        }
        EOT
        }
    ]

    output = {
        location = "github://abbeylabs/how-abbey-works-blog-code/access.tf"
        append = <<-EOT
        resource "aws_iam_user_group_membership" "admin_membership_{{ .data.system.abbey.identities.aws_iam.name }}" {
            groups = [
                aws_iam_group.admin_group.name,
            ]
            user = "{{ .data.system.abbey.identities.aws_iam.name }}"
        } 
        EOT
    }
}

resource "abbey_identity" "johndoe" {
    abbey_account = "john.doe@abbey.io"
    source = "aws_iam"
    metadata = jsonencode(
        {
            name = "john"
        }
    )
}

resource "aws_iam_group" "admin_group" {
  name = "admin"
  path = "/"
}
