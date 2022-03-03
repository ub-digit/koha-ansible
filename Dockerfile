FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y gnupg

RUN echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main' > /etc/apt/sources.list.d/ansible.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
 && apt-get update \
 && apt-get install -y ansible build-essential libmariadb-dev libmariadb-dev-compat libyaz-dev libnet-z3950-zoom-perl

WORKDIR /install
COPY requirements.yml /install/
RUN ansible-galaxy install -r requirements.yml

COPY server-setup.yml .
COPY vars vars
COPY files files
COPY templates templates
COPY devbox devbox
RUN mv devbox/vault.yml vars/vault.yml
RUN ansible-playbook -i devbox server-setup.yml
COPY koha-setup.yml .
RUN ansible-playbook -i devbox koha-setup.yml

COPY . /install/
RUN mv devbox/vault.yml vars/vault.yml
RUN ansible-playbook -i devbox koha-config.yml
RUN ansible-playbook -i devbox koha-instance-setup.yml
RUN chown -R koha-koha:koha-koha /home/apps/koha-repo
WORKDIR /home/apps/koha-repo
ENV SHELL=/bin/bash
CMD ["apachectl", "-DFOREGROUND", "-e", "debug"]
