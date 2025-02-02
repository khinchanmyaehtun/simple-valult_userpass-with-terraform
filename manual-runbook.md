# enable auth method `userpass`

# userpass_team1
type : userpass
path : team1

# userpass_team2
type : userpass
path : team2


# team1_policy
name = team1-policy
policy = 
  path "kvv2-team1/*" {
  capabilities = ["read", "list"]
}

# team2_policy
name = team2-policy
policy = 
  path "kvv2-team2/*" {
  capabilities = ["read", "list"]
}

# enabling secrets engine - `vault_mount`
type = "kv-v2"
path = "kvv2-team1" 

type = "kv-v2"
path = "kvv2-team2" 

# creating secrets 
team1 - username,password for aws-master-account and aws-dev-account
team2 - username, password for aws-master-account and aws-dev-account