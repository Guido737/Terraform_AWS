terraform {
  required_providers {
    dominos = {
      source  = "dominos.com/myorg/dominos"
      version = "1.0.0"
    }
  }
}

provider "dominos" {
  first_name    = "Charlie"
  last_name     = "Chaplin"
  email_address = "chaplin@gmail.com"
  phone_number  = "+1-243-252356644"
}

data "dominos_address" "myaddress" {
  street = "3444 NY George st"
  city   = "Hillsboro"
  state  = "OR"
  zip    = "24323"
}

data "dominos_store" "closet" {
  address_url_object = data.dominos_address.myaddress.url_object
}

data "dominos_menu_item" "item" {
  store_id     = data.dominos_store.closet.store_id
  query_string = ["pizza"]
}

resource "dominos_order" "myorder" {
  address_api_object = data.dominos_address.myaddress.api_object
  store_id           = data.dominos_store.closet.store_id
  item_codes         = ["PBKIREZA", "D20BZRO"]
}

#----------------------------------------------------------------------------------------------------------------------------------

output "my_address" {
  value = "${data.dominos_address.myaddress.street}, ${data.dominos_address.myaddress.city}, ${data.dominos_address.myaddress.zip}"
}

output "dominos_store" {
  value = data.dominos_store.closet.store_id
}

output "dominos_menu" {
  value = data.dominos_menu_item.item
}

output "dominos_order" {
  value = dominos_order.myorder
}
