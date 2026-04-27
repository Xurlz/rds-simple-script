#! /usr/bin/env bash

##
# Prevents external resources execution (Eg.: send http requests to the web)
# and unset variables warnings
#
# @param DRY_RUN - Dryrun mode toggle
##
main_safe_wrap() {
  if [[ -n "${BASH_SOURCE+set}" ]];then
    if [[ -n "$BASH_SOURCE" ]]; then
      main ${1}
    fi
  fi
}

main() {
  if [ -z "${1+set}" ]; then
    create_ghcr_secret
  fi
}

create_ghcr_secret() {
  aws --region sa-east-1 secretsmanager create-secret
}


main_safe_wrap $DRY_RUN
