Vagrant.configure("2") do |config|

  config.vm.hostname = "kohasetup"
  config.vm.network "private_network", ip: "172.20.20.20"

  config.vm.provider :virtualbox do |v|
    v.memory = 2048
  end

  #config.vm.box = "bento/ubuntu-18.04"
  config.vm.box = "bento/debian-10"

  #config.vm.network :forwarded_port, guest: 6001, host: 6001, auto_correct: true  # SIP2
  #config.vm.network :forwarded_port, guest: 80,   host: 8080, auto_correct: true  # OPAC
  #config.vm.network :forwarded_port, guest: 8080, host: 8081, auto_correct: true  # INTRA
  #config.vm.network :forwarded_port, guest: 9200, host: 9200, auto_correct: true  # ES

  #
  # Run Ansible from the Vagrant Host
  #
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "site.yml"
    ansible.vault_password_file = "ansible_password"
    ansible.extra_vars = {
      environment_name: "vagrant",
      koha_home: "/home/{{ ansible_user }}/kohadev/current",
      koha_po_files_path: "/home/{{ ansible_user }}/koha-staging/shared/misc/translator/po",
      koha_instance_name: "koha",
      koha_db_password: "koha_password",
      gobi_report_mail_to: "david.gustafsson@ub.gu.se,g.katalog@ub.gu.se",
      gobi_error_mail_to: "david.gustafsson@ub.gu.se,g.katalog@ub.gu.se,stefan.berndtsson@ub.gu.se"
    };
  end

  sync_repo_dir = ENV['KOHA_REPO']
  if sync_repo_dir
    config.vm.synced_folder sync_repo_dir, "/home/vagrant/kohadev/current", type: "nfs"
  end
end
