# koha-ansible

## Ansible setup

[Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

(A newer version is required, probably newer than 5.0.x, verified to work with >= 5.4.x)

Install playbook dependencies:

`ansible-galaxy install -r requirements.yml`

## Vagrant setup

For some reason sudo apt-get update --fix-missing needs to be run for newly provisioned vagrant box.
Does not seems to be an issue for other environments.

For test setup, after running vagrant up (which also runs provison), get box id by running:

`vagrant global-status`

Set KOHA_DEPLOY_TESTING_DEVBOX_ID:

`export KOHA_DEPLOY_TESTING_DEVBOX_ID=<id>`

This environmental variable is used by Koha-deply "testing" stage (in config/deploy/testing.rb)
and should be enough to be able to deploy to the vagrant box.

## Deployment

`ansible-playbook --vault-password-file .vault_password -i <stage> <playbook>.yml`

For example:

`ansible-playbook --vault-password-file .vault_password -i staging gobi.yml`

Where .vault_password is a file containing the vault password in plain text.

`deploy_jobs.sh` is a helper script for deploying miscellaneous scripts and jobs, but not Koha itself (the `site.yml` playbook).

## Database import/export tasks

Koha database can be exported and downloaded to local data directory (`./data`) by running the `koha-db-fetch.yml` playbook.

`koha-db-import.yml` will import the sql-dump currently present in the local data directory. Dumps may also be placed
manually in this directroy instead of running `koha-db-fetch.yml`. The file must be compressed and named `kohadump.sql.gz`.

## Post import tasks

After importing a production database, run `koha-db-anonymize.yml` to anonymize sensitive use data, and `koha-set-environment-preferences.yml` to set preferences for the specific environment.

## Setting up a new environment

Since some capistrano tasks depends on a working Koha environment, it's easiest to initially manually copy the Koha repo into the target `koha_home` directory (for example `/home/apps/koha-lab/current`) and then run `site.yml`. After this the temporary source directory can be removed and capistrany be used for deployment.

## Set ansible vault password environment variable
`export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/repo/.vault_password`

## Vault git config (diffs for vault-encryted files)
`git config --global diff.ansible-vault.textconv "ansible-vault view"`
