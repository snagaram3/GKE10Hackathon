
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for networking and GKE"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the zonal cluster"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name for the GKE cluster"
  type        = string
  default     = "kubestronautinmaking-gke-1"
}
