resource "google_sql_database_instance" "pgsql-instance" {
  name             = "pg-instance"
  project          = var.project
  region           = "us-central1"
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
    edition = "ENTERPRISE"
    password_validation_policy {
      min_length                  = 6
      reuse_interval              = 2
      complexity                  = "COMPLEXITY_DEFAULT"
      disallow_username_substring = true
      password_change_interval    = "30s"
      enable_password_policy      = true
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}

resource "google_sql_user" "postgres_user" {
  name     = "developer"
  instance = google_sql_database_instance.pgsql-instance.name
  password = "Prabalsaxena98@"
  project  = var.project
}

terraform {
  backend "gcs" {
    bucket  = "onlineliquorservicesbucket"
    prefix  = "terraform/postgresql/tfstate"
  }
}