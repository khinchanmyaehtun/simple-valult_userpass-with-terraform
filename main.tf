# Enabling authentication method
resource "vault_auth_backend" "userpass_team1" {
  type = "userpass"
  path = "team1"
}

resource "vault_auth_backend" "userpass_team2" {
  type = "userpass"
  path = "team2"
}

#Creating Policies
resource "vault_policy" "team1_policy" {
  name = "team1-policy"

  policy = <<EOT
    path "kvv2-team1/*" {
    capabilities = ["read", "list"]
}

path "cubbyhole/*" {
capabilities = ["deny"]
}
EOT
}

resource "vault_policy" "team2_policy" {
  name = "team2-policy"

  policy = <<EOT
    path "kvv2-team2/*" {
    capabilities = ["read", "list"]
}
EOT
}

#Enablilng secrete Engine for team1
resource "vault_mount" "team1_kvv2_mount" {
  path        = "kvv2-team1"
  type        = "kv-v2"
  description = "kv-v2 secrets engine mounted at the path kvv2-team1"
}

resource "vault_mount" "team2_kvv2_mount" {
  path        = "kvv2-team2"
  type        = "kv-v2"
  description = "kv-v2 secrets engine mounted at the path kvv2-team2"
}


#Creating master_account secres in the kvv2-team1 Secret Engine
resource "vault_kv_secret_v2" "kvv2_team1_master_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-master-account"
  data_json = jsonencode(
    {
      username = "master-admin"
      password = "master-Passw0rd"
    }
  )
}

#Creating dev_account secrets in the kvv2-team1 Secret Engine
resource "vault_kv_secret_v2" "kvv2_team1_dev_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-dev-account"
  data_json = jsonencode(
    {
      username = "dev-admin"
      password = "dev-Passw0rd"
    }
  )
}


#Creating master_account secrets in the kvv2-team2 Secret Engine
resource "vault_kv_secret_v2" "kvv2_team2_master_secret" {
  mount = vault_mount.team2_kvv2_mount.path
  name = "aws-master-account"
  data_json = jsonencode(
    {
        username = "master-admin"
        password = "master-Passw0rd"
    }
  )
}
#Creating dev_account secrets in the kvv2-team2 Secret Engine
resource "vault_kv_secret_v2" "kvv2_team2_dev_secret" {
  mount = vault_mount.team2_kvv2_mount.path
  name = "aws-dev-account"
  data_json = jsonencode(
    {
        username = "dev-admin"
        password = "dev-Passw0rd" 
    }
  )
}


# Creating user with policy binded in the team1 userpass authmethod
resource "vault_generic_endpoint" "team1_user_account" {
  depends_on = [vault_auth_backend.userpass_team1]
  path       = "auth/team1/users/admin1"
  data_json  = <<EOT
    {
    "password" : "admin",
    "policies" : ["team1-policy"]
    }
    EOT
}


# Create user with policy binded in the team2 userpass authmethod
resource "vault_generic_endpoint" "team2_user_account" {
  depends_on = [vault_auth_backend.userpass_team2]
  path       = "auth/team2/users/admin2"
  data_json  = <<EOT
    {
    "password" : "ADMIN",
    "policies" : ["team2-policy"]
    }
    EOT
}