# TODOS
# * Add nodejs cookbook so ubuntu has a js runtime for rails
# * Use site cookbooks https://github.com/gitlabhq/gitlab-vagrant-vm
# * See if you can use the apt cookbook resource to easily install apt packages like those in the install.sh script
# * Add dotfiles and other env configs for vagrant user
# 

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Hostname will be the name of the source box (precise64) unless specified
  # config.vm.host_name = 'rails-dev'

  # NFS share requires host only networking to be enabled. Add multiple entries
  # to have multiple vms running on the same subnet. Currently there is an issue
  # where using nfs causes the file permission to set to be 501:dialout. This is
  # caused by the nfs mounting in OSX. For now it is best to just avoid nfs
  #
  # Enabling the host only IP makes it easier to manually SSH into the box if
  # needed with the following command. This is enabled in Vagrantfile.pkg but is
  # not needed here in the primary Vagrantfile.
  # 
  #     ssh vagrant@10.11.12.13 -p 2222 -i ~/.vagrant.d/insecure_private_key
  # 
  # config.vm.network :hostonly, "10.11.12.13"
  # config.vm.network :hostonly, "10.11.12.14"

  # If you want to directly access mysql the port needs to be fowarded, the bind
  # address needs to allow the remote host (the mysql recipe sets this to the vm
  # so it works by default) and allow_remote_root must be set to true in the
  # mysql cookbook attribute. Your mysql client will make a connection to your
  # mac (127.0.0.1:3333 which will then foward the traffic to port 3306 on the
  # guest vm. If you want to use an ssh connection instead youll need to use the
  # key ~/.vagrant.d/insecure_private_key
  #
  config.vm.forward_port 3000, 3000   # rails (localhost:3000)
  config.vm.forward_port 3306, 3307   # mysql
  config.vm.forward_port 5432, 5433   # postgresql
  config.vm.forward_port 27017, 27018  # mongodb
  config.vm.forward_port 55672, 55673  # rabbitmq

  # Generally you want to use :nfs shares for better performance. You'll be
  # prompted for your password when bring up the VM.
  # 
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"
  # config.vm.share_folder "code", "/home/vagrant/code", ".", :create => true, :nfs => true
  config.vm.share_folder "code", "/home/vagrant/code", ".", :create => true

  # Vagrant assumes the base box has already been bootstrapped. If you need
  # additional bootstrapping (maybe you're using the example box) your options
  # are:
  # 
  # * Shell provision with inline command
  # * Shell provision with URL to gist
  # * Create your own base base box with veewee
  # 
  # Below are some examples. Common tasks might include updating apt or other
  # system packages, installing ruby, installing gems
  #
  # config.vm.provision :shell, :inline => "apt-get -y install curl"
  # config.vm.provision :shell, :inline => "curl -L https://raw.github.com/gist/2775351/ea159cf6d5886b8754b0bb4e8e9180eb70762852/chef_solo_bootstrap.sh | bash"
  # config.vm.provision :shell, :inline => "wget -O - https://raw.github.com/gist/2775351/ea159cf6d5886b8754b0bb4e8e9180eb70762852/chef_solo_bootstrap.sh | bash"
  # config.vm.provision :shell, :path   => "install.sh"
  # config.vm.provision :shell, :inline => "apt-get -y update"
  # config.vm.provision :shell, :inline => "apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev"
  # config.vm.provision :shell, :inline => "gem install ruby-shadow --no-ri --no-rdoc"
  
  # Primary provisioning
  config.vm.provision :chef_solo do |chef|
    # chef.log_level = :debug                        # default is :warn
    chef.cookbooks_path = "cookbooks"
    
    # The following recipes would not be needed in a chef-solo project because
    # they would be installed from the bootstrap script (apt, build-essential,
    # ruby-shadow). They are needed with vagrant because example vagrant box
    # isn't properly bootstrapped. You could also use veewee to create your own
    # base box that has all the packages you need.
    #
    chef.add_recipe "apt"
    
    #
    # The build essential package must use the compiletime attr otherwise ruby-
    # shadow wont compile because make is missing
    #
    chef.add_recipe "build-essential"
    
    
    # More basic packages
    chef.add_recipe "git"
    chef.add_recipe "networking_basic"
    
    
    # Install newer version of ruby
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::system"
    
    
    # Databases
    # chef.add_recipe "mysql::ruby"           # useful only if you need the mysql gem during compile time. To get the gem for your apps, use bundler during deployment
    chef.add_recipe "mysql::server"           # clint recipe is included in server
    
    # chef.add_recipe "postgresql::ruby"      # useful only if you need the mysql gem during compile time. To get the gem for your apps, use bundler during deployment
    chef.add_recipe "postgresql::server"
    
    
    # Web server
    chef.add_recipe "nginx::source"
    
    
    # Users
    # chef.add_recipe "user"
    # chef.add_recipe "user::data_bag"
    
    
    # MongoDB - not working yet
    # chef.add_recipe "mongodb::10gen_repo"
    # chef.add_recipe "mongodb"

    # Node
    chef.add_recipe "nodejs"
    chef.add_recipe "nodejs::npm"
    
    # Cookbook attributes
    chef.json = {
      :build_essential => {
        :compiletime => true                     # used for ruby-shadow
      },
      :networking => {
        :packages => %w[ curl wget rsync ]
      },
      :rbenv => {
        :rubies => ['1.9.3-p194'],
        :global => '1.9.3-p194',
        :gems => {
          '1.9.3-p194' => [
            {:name => 'bundler'},
            {:name => 'rake'}
          ]
        }
      },
      # Create shadow passwords with the following command
      # 
      # openssl via `openssl passwd -1 yourpassword`
      # 
      :mysql => {
        :server_root_password   => 'password',
        :server_repl_password   => 'password',
        :server_debian_password => 'password',
        :allow_remote_root      => true          # access mysql root from remote (for development only)
      },
      :postgresql => {
        :listen_addresses => '*',
        :password => {
          :postgres => 'password'
        }
      },
      # The nginx cookbook doesn't create a app conf file for you. You'll have
      # to add your own (ideally to app_root/config/nginx.conf) and symlink it
      # to sites-enabled. By default nginx will create and enable /etc/nginx
      # /sites-enabled/default. We overwrite the default at the end of this file
      :nginx => {
        :version => '1.2.2'                      # default is set but setting here helps
      }
    }
  end

  # Only run the shell provision when creating the vm for the first time,
  # otherwise everything in `install.sh` will be executed again and could cause
  # errors.
  #       
  config.vm.provision :shell, :path => "install.sh"

  # Vagrant runs all shell provsion commands as the root user. These are the
  # "last mile" steps need to finish deploying a rails app with Vagrant. They
  # include:
  # 
  # * Copying the nginx.conf file to sites-available folder
  # * Restarting nginx
  # * Running bundle install
  # * Starting Unicorn
  # 
  # In a VPS you wouldn't have to do this because you would use a deployment
  # tool like capistrano to install gems.

  # Overwrite the default site config with this app's site config
  # 
  # config.vm.provision :shell, :inline => "cp /home/vagrant/chef-solo-vagrant/config/nginx.conf /etc/nginx/sites-available/default"
  # config.vm.provision :shell, :inline => "service nginx restart"

  # The commands below needs to be ran as the vagrant user. You can also run
  # the following command from the mac terminal`
  # 
  # vagrant ssh -c 'cd /home/vagrant/chef-solo-vagrant && bundle install --system && bundle exec foreman start'
  # 
  # config.vm.provision :shell, :inline => "su -l -c 'cd /home/vagrant/chef-solo-vagrant && bundle install' vagrant"
  # config.vm.provision :shell, :inline => "su -l -c 'mkdir -p /home/vagrant/mystore/tmp/pids' vagrant"
  # config.vm.provision :shell, :inline => "su -l -c 'cd /home/vagrant/chef-solo-vagrant && bundle exec foreman start' vagrant"
  # config.vm.provision :shell, :inline => "cd /home/vagrant/chef-solo-vagrant && foreman export upstart /etc/init -a chef-solo-vagrant -u vagrant && start chef-solo-vagrant"

  # The Postgresql cookbook won't accept client connections from anything but
  # localhost. We have to add an entry to pg_hba.conf until opscode merges in
  # fnichol's pull request (https://github.com/opscode-
  # cookbooks/postgresql/pull/9)
  # 
  # host    all         all         0.0.0.0/0             md5
  # 
  # config.vm.provision :shell, :inline => "echo -e 'host\tall\tall\t0.0.0.0/0\tmd5' >> /etc/postgresql/9.1/main/pg_hba.conf"
  # config.vm.provision :shell, :inline => "service postgresql restart"
end
