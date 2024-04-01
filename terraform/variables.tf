## Mandatory changes

variable "project" {
  description = "Project"
  default     = "dezc24-exoplanets"
}

variable "bq_dataset_name" {
  description = "Datawarehouse Name"
  #Update the below to what you want your dataset to be called
  default     = "dw_exo_planets"
}

variable "data-lake-bucket" {
  description = "Data Lake"
  #Update the below to a unique bucket name
  default     = "dl_exoplanets"
}

## Optional changes below

variable "bq_dataset_name" {
  description = "dbt dataset"
  #Update the below to what you want your dataset to be called
  default     = "dbt_gdumiense"
}

variable "credentials" {
  description = "My Credentials"
  default     = "../mage/keys.json"
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

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
} 