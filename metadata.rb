name             'pacemaker'
maintainer       'Target Corporation'
maintainer_email 'Travis.Killoren@Target.com'
license          'Apache 2.0'
description      'Installs/Configures pacemaker'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'hostsfile'
depends 'chef-vault'
