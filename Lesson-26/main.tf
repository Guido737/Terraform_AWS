#--------------------------------------------------------------
# My Terraform
#
# Use Terraform with GCP - Google Cloud Platform
#
# Made By Creator Eversor  
#--------------------------------------------------------------

//export GOOGLE_CLOUD_KEYFILE_JSON="gcp-creds-json"

provider "google" {
  credentials = file("mygcp-creds")
  project     = "My-GPC-Project-91296"
  region      = "us-west1"
  zone        = "us-west1-b"
}

resource "google_compute_instance" "my_server" {
  name         = "my-gcp-server"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}
