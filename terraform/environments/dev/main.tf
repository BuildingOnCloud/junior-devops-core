# --- DevOps Project 2: Dev Environment Root Composition ---

# 1. Instantiate the reusable network tier
module "dev_network" {
  source              = "../../modules/network"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  environment         = "dev"
}

# 2. Instantiate the compute tier, feeding it the network module's dynamic output
module "dev_compute" {
  source           = "../../modules/compute"
  instance_type    = "t3.micro"
  vpc_id           = module.dev_network.vpc_id
  environment      = "dev"
  public_subnet_id = module.dev_network.public_subnet_id
  key_name         = "junior-devops-admin-key"
}

# 3. Instantiate the isolated cloud storage object tier
module "dev_storage" {
  source      = "../../modules/storage"
  bucket_name = "buildingoncloud-dev-artifact-bucket-01"
  environment = "dev"
}
