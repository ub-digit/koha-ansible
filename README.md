# koha-ansible

For test setup, after running vagrant up (which also runs provison), get box id by running:

`vagrant global-status`

Set KOHA_DEPLOY_TESTING_DEVBOX_ID:

`export KOHA_DEPLOY_TESTING_DEVBOX_ID=<id>`

Adjust apache-configuration by running:

`cap testing koha:adjust-apache-conf`

Right now plack is not enabled or started automatically, so inside the box
enable plack configuration in /etc/apache2/kohadev.conf and run:

`koha-plack --start kohadev`

Deployment:

`ansible-playbook --vault-password-file ansible_password -i <stage> <playbook>.yml`

For example:

`ansible-playbook --vault-password-file ansible_password -i staging gobi.yml`

Where ansible_password is a file containing the vault password in plain text.
