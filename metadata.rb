name             'apache'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures apache'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.5' "Update for the dev and default environments"
# add iptables to runlist via knife command knife node run_list add iptables
depends "iptables"