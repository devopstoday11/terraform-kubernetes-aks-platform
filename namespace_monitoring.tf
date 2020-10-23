# Monitoring

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"

    annotations = {
      "logging.csp.vmware.com/fluentd-status" = ""
    }

    labels = {
      control-plane = "monitoring"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["logging.csp.vmware.com/fluentd-status"]
    ]
  }
}

module "namespace_monitoring" {
  source = "git::https://github.com/canada-ca-terraform-modules/terraform-kubernetes-namespace.git?ref=v2.1.0"

  name = "${kubernetes_namespace.monitoring.metadata.0.name}"
  namespace_admins = {
    users = []
    groups = [
      "${var.kubernetes_rbac_group}"
    ]
  }

  # CICD
  ci_name = "deploy"

  # Image Pull Secret
  enable_kubernetes_secret = "${var.enable_kubernetes_secret}"
  kubernetes_secret        = "${var.kubernetes_secret}"
  docker_repo              = "${var.docker_repo}"
  docker_username          = "${var.docker_username}"
  docker_password          = "${var.docker_password}"
  docker_email             = "${var.docker_email}"
  docker_auth              = "${var.docker_auth}"

  dependencies = []
}
