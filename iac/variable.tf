variable "project_id" {
  description = "The GCP project ID to deploy the resources in."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy the resources in."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to deploy the resources in."
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "The name for the GKE cluster."
  type        = string
  default     = "gke-cluster"
}

variable "node_count" {
  description = "The number of nodes in the GKE cluster."
  type        = number
  default     = 1
}