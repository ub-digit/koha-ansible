FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y gnupg

RUN echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main' > /etc/apt/sources.list.d/ansible.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
 && apt-get update \
 && apt-get install -y sudo ansible build-essential libmariadb-dev libmariadb-dev-compat libyaz-dev libnet-z3950-zoom-perl

RUN useradd -m -d /home/apps apps
RUN echo 'apps ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/apps

WORKDIR /install
USER apps
COPY requirements.yml /install/
RUN ansible-galaxy install -r requirements.yml

COPY server-setup.yml .
COPY vars vars
COPY files files
COPY templates templates
COPY devbox devbox
USER root
RUN mv devbox/vault.yml vars/vault.yml
USER apps
RUN ansible-playbook -i devbox server-setup.yml
COPY koha-setup.yml .
RUN ansible-playbook -i devbox koha-setup.yml

COPY . /install/
USER root
RUN mv devbox/vault.yml vars/vault.yml
USER apps
RUN ansible-playbook -i devbox koha-config.yml
RUN ansible-playbook -i devbox koha-instance-setup.yml
RUN mkdir /home/apps/img
USER root
RUN mv /install/files/background-image-devbox.png /home/apps/img/background-image-devbox.png
RUN mv /install/files/favicon-devbox.ico /home/apps/img/favicon-devbox.ico
RUN chown -R koha-koha:koha-koha /home/apps/koha-repo
USER root
WORKDIR /home/apps/koha-repo
ENV SHELL=/bin/bash
CMD ["apachectl", "-DFOREGROUND", "-e", "debug"]
