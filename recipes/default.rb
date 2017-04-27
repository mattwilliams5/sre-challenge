#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2017, AWeber
#
# All rights reserved - Do Not Redistribute
#

# Install packages
execute "apt-get update -y" do
end

%w(openssl apache2).each do |pkg|
  apt_package pkg do
    action :install
  end
end

# Set up apache 
node["apache"]["sites"].each do |sitename, data|
  document_root = "/var/www/html/#{sitename}"

  directory document_root do
	mode "0755"
	recursive true
  end

if node["platform"] == "ubuntu"
	template_location = "/etc/apache2/sites-enabled/#{sitename}.conf"
# Future build out
elsif node["platform"] == "centos"
	template_location = "/etc/httpd/conf.d/#{sitename}.conf"
end

# Template set up

template '/tmp/keys.sh' do
  source 'keys.sh.erb'
  mode 0664
  owner 'root'
  group 'root'
end

template template_location do
	source "vhost.erb"
	mode "0644"
	variables(
		:document_root => document_root,
		:port	=> data["port"],
		:domain => data["domain"]
	)  	
	notifies :restart, "service[httpd]"
end

template "/var/www/html/#{sitename}/index.html" do
	source "index.html.erb"
	mode "0644"
	variables(
		:site_title => data["site_title"],
		:comingsoon => "Coming soon!",
		:author => node["author"]["name"]
	)
end
end

execute "rm /etc/httpd/conf.d/welcome.conf" do
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end

execute "rm /etc/httpd/conf.d/README" do
	only_if do
		File.exist?("/etc/httpd/conf.d/README")
	end
end

# Configure keys and ssl
execute "Configure keys" do
  command "bash /tmp/keys.sh"
end

exexute "SSL" do
  command "sudo a2enmod rewrite"
end

service "httpd" do
	service_name node["apache"]["package"]
	action [:enable, :start]
end

