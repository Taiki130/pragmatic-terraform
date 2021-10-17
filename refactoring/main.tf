resource "null_resource" "overwrite" {}
resource "null_resource" "bar" {}

resource "null_resource" "after" {}

module "after" {
  source = "./rename"
}