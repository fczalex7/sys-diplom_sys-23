terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

#provider
provider "yandex" {
  token     = "***"
  cloud_id  = "b1g7ek4ruan71tg0okvd"
  folder_id = "b1grk2k83sn3mnce2akd"
}
