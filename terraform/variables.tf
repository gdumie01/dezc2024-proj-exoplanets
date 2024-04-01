variable "credentials" {
  description = "My Credentials"
  default     = "../mage/keys.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "dezc24-exoplanets"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "europe-west6"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "nasa_exo_planets"
}

variable "data-lake-bucket" {
  description = "My Storage Bucket for new data"
  #Update the below to a unique bucket name
  default     = "dezc2024-project-exoplanets"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
} 