#!/usr/bin/env sh

main() {
  create-instance
}

create-instance() {
  aws --region sa-east-1 rds create-db-instance \
     --db-instance-identifier database-1 \
     --db-instance-class db.t4g.micro \
     --engine postgres \
     --engine-version '17.2' \
     --master-username `rds_master_username` \
     --master-user-password `rds_master_password` \
     --allocated-storage 20 \
     --storage-encrypted \
     --availability-zone sa-east-1a \
     --vpc-security-group-ids sg-0dc8f66d981602e1e \
     --db-parameter-group-name default.postgres17 \
     --backup-retention-period 0 \
     --option-group-name default:postgres-17 \
     --db-subnet-group-name default-vpc-0b1308f5933a64645
}

rds_master_username() {
  aws --region sa-east-1 secretsmanager get-secret-value --secret-id rds/postgres/master-password | jq '.SecretString' | sed 's/\\//g' | cut -c2-56 | jq -r '.username'
}

rds_master_password() {
  aws --region sa-east-1 secretsmanager get-secret-value --secret-id rds/postgres/master-password | jq '.SecretString' | sed 's/\\//g' | cut -c2-56 | jq -r '.password'
}

main
