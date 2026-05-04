# ──────────────────────────────────────────────────────────────
# modules/ecr/main.tf
# ECR Repository with lifecycle policy and image scanning
# ──────────────────────────────────────────────────────────────

# ── KMS Key for ECR encryption (CKV_AWS_136) ───────────────────
resource "aws_kms_key" "ecr" {
  description             = "KMS key for ECR repository encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.name_prefix}-ecr-kms-key"
  }
}

resource "aws_kms_alias" "ecr" {
  name          = "alias/${var.name_prefix}-ecr"
  target_key_id = aws_kms_key.ecr.key_id
}

resource "aws_ecr_repository" "app" {
  name                 = var.name_prefix
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Use a Customer Managed Key for encryption (CKV_AWS_136)
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr.arn
  }

  tags = {
    Name = "${var.name_prefix}-ecr"
  }
}

# Keep last 10 tagged images; remove untagged after 1 day
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images after 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep last 10 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release", "prod", "dev"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = { type = "expire" }
      }
    ]
  })
}
