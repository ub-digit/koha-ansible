#!/bin/bash

# usage ./deploy_jobs.sh <stage>

if [ -z "$1" ]; then
  echo "Missing argument: <stage>"
  echo "Usage: $0 <stage>"
  exit 1;
fi

run_playbook () {
  echo "RUNNING $2" && ansible-playbook --vault-password-file ansible_password -i $1 $2
}

run_playbook $1 adjustlibris.yml
run_playbook $1 auto-enable-printer.yml
run_playbook $1 afetchlibris.yml
run_playbook $1 gobi.yml
run_playbook $1 mailhog.yml
run_playbook $1 libris-oai-import.yml
run_playbook $1 loadlibris.yml

if [[ "$1" == "production" ]]; then
  run_playbook $1 upload-edifact.yml
  run_playbook $1 kvinnsam-libris2primo.yml
  run_playbook $1 papercut.yml
  run_playbook $1 print-notice.yml
  run_playbook $1 primo-export.yml
fi
