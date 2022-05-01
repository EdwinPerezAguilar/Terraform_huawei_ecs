provider "huaweicloud" {
            #HW_REGION_NAME
  region     = var.region_az
  access_key = var.ak_huawei
  secret_key = var.sk_huawei
  # the auth url format follows: https://iam.{region_id}.myhwclouds.com:443/v3
  auth_url    = "https://iam.${var.region_az}.myhuaweicloud.com/v3"
}