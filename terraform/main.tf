provider "google" {
  project     = "${var.project-name}"
  region      = "${var.region}"
}

// Create a new instance
resource "google_container_cluster" "dod-cluster-1" {
  name               = "terraform-builder-gcs-backend"
  zone               = "${var.region}"
  initial_node_count = "1"

  node_config {
    disk_size_gb  = "100"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only"
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]

    labels {
      reason = "dod-infra"
    }

    tags = ["example"]
  }
}
