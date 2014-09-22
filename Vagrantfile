ubuntu_box_name = 'opscode_ubuntu-12.04_chef-11.2.0'
ubuntu_box_url  = "https://opscode-vm.s3.amazonaws.com/vagrant/#{ubuntu_box_name}.box"

Vagrant.configure("2") do |config|
  ubuntu.vm.box               = ubuntu_box_name
  ubuntu.vm.box_url           = ubuntu_box_url
  config.vm.guest = :ubuntu
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "minitest-handler"
    chef.add_recipe "netscaler::test_server"
  end
end
