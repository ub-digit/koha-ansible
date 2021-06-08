#!/bin/bash

# usage ./deploy_jobs.sh <stage>

if [ -z "$1" ]; then
  echo "Missing argument: <stage>"
  echo "Usage: $0 <stage>"
  exit 1;
fi

printf '%s\0' \
adjustlibris.yml \
auto-enable-printer.yml \
edifact.yml \
fetchlibris.yml \
gobi.yml \
kvinnsam-libris2primo.yml \
libris-oai-import.yml \
loadlibris.yml \
papercut.yml \
print-notice.yml \
primo-export.yml\
| xargs --null -I{ bash -c "echo 'RUNNING {' && ansible-playbook --vault-password-file ansible_password -i $1 {"
