# ──────────────────────────────────────────────────────────────
# modules/waf/main.tf
# WAFv2 REGIONAL WebACL with AWS Managed Core Rule Set
# ──────────────────────────────────────────────────────────────

resource "aws_wafv2_web_acl" "main" {
  name        = "${var.name_prefix}-web-acl"
  description = "WAFv2 WebACL with AWS Managed Core Rule Set"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # ── AWS Managed Core Rule Set ─────────────────────────────────
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 10

    override_action {
      dynamic "none" {
        for_each = var.block_mode ? [1] : []
        content {}
      }
      dynamic "count" {
        for_each = var.block_mode ? [] : [1]
        content {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-common-rule-set"
      sampled_requests_enabled   = true
    }
  }

  # ── Known Bad Inputs (includes Log4j / CVE-2021-44228) ───────────
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 20

    override_action {
      dynamic "none" {
        for_each = var.block_mode ? [1] : []
        content {}
      }
      dynamic "count" {
        for_each = var.block_mode ? [] : [1]
        content {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-known-bad-inputs"
      sampled_requests_enabled   = true
    }
  }



  # ── Amazon IP Reputation List ─────────────────────────────────
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 30

    override_action {
      dynamic "none" {
        for_each = var.block_mode ? [1] : []
        content {}
      }
      dynamic "count" {
        for_each = var.block_mode ? [] : [1]
        content {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-ip-reputation"
      sampled_requests_enabled   = true
    }
  }

  # ── Rate Limiting (per-IP) ────────────────────────────────────
  rule {
    name     = "RateLimitPerIP"
    priority = 40

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit_per_ip
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-web-acl"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.name_prefix}-web-acl"
  }
}

# ── KMS Key for WAF CloudWatch Logs (CKV_AWS_158) ─────────────────
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "waf_logs" {
  description             = "KMS key for WAF CloudWatch log encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.id}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "${var.name_prefix}-waf-logs-kms-key"
  }
}

resource "aws_kms_alias" "waf_logs" {
  name          = "alias/${var.name_prefix}-waf-logs"
  target_key_id = aws_kms_key.waf_logs.key_id
}

# ── CloudWatch Log Group for WAF ───────────────────────────────
# WAF log group name MUST start with "aws-waf-logs-"
resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-${var.name_prefix}"
  retention_in_days = 365      # CKV_AWS_338: retain logs for at least 1 year
  kms_key_id        = aws_kms_key.waf_logs.arn # CKV_AWS_158: encrypt with CMK

  tags = {
    Name = "aws-waf-logs-${var.name_prefix}"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
}
