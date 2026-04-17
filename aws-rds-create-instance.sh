#!/usr/bin/env bash

##
# @param $1 DRY_RUN - Dont call the external resources (`aws` command) if is
# set
##
main() {
  if [ -z "${1+set}" ]; then create_instance; fi
}

create_instance() {
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
  set -uo pipefail
  aws --region sa-east-1 secretsmanager get-secret-value --secret-id rds/postgres/master-password | jq -r '.SecretString' | sed 's/\\//g' | jq -r '.username' 
}

rds_master_password() {
  set -uo pipefail
  aws --region sa-east-1 secretsmanager get-secret-value --secret-id rds/postgres/master-password | jq -r '.SecretString' | sed 's/\\//g' | jq -r '.password'
}

# It script was not called with `.` or `source`
if [[ -n "${BASH_SOURCE+set}" ]];then
  if [[ -n "$BASH_SOURCE" ]]; then
    # Executes the main function external resources if `DRY_RUN` variable is set
    main $DRY_RUN
  fi
fi

# if [[ -n ${ZSH_SUBSHELL+set} ]];then
#   echo "$ZSH_SUBSHELL"
#   if [[ "$ZSH_SUBSHELL" = "0" ]]; then echo main; fi
# fi
# [ -v ZSH_SUBSHELL ] && [ "$ZSH_SUBSHELL" = "0" ] && echo main
# if [ -z "$BASH_SOURCE" ] || [ "$ZSH_SUBSHELL" = "0" ]; then
#   echo main
# fi

