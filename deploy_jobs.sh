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
upload-edifact.yml \ # endast prod
fetchlibris.yml \
gobi.yml \
mailhog.yml \
kvinnsam-libris2primo.yml \ # endast prod
libris-oai-import.yml \
loadlibris.yml \
papercut.yml \ # endast prod
print-notice.yml \ # endast prod
primo-export.yml\ # endast prod
| xargs --null -I{ bash -c "echo 'RUNNING {' && ansible-playbook --vault-password-file ansible_password -i $1 {"
