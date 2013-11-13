class dopostfix (

  # by default we don't relay to an external server
  $relay = false,
  $smtp_hostname = undef,
  
  # we don't currently use port
  $smtp_port = 587,

  # smtp authentication credentials
  $smtp_auth = false,
  $smtp_username = 'web',
  $smtp_password = 'admLn**',

  # monitor by default
  $monitor = true,

  $force_restrict_relay = false,

) inherits dopostfix::params {

  # setup variables for template
  $relayhost = "[${smtp_hostname}]"

  # monitor if turned on
  if ($monitor) {
    class { 'dopostfix::monitor' :
    }
  }

  # install OS dependent packages
  case $operatingsystem {
    centos, redhat, fedora: {
      package { 'postfix-install-prereq' :
        name => ['cyrus-sasl-plain'],
        ensure => 'present',
      }
    }
    ubuntu, debian: {
      package { 'postfix-install-prereq' :
        name => ['sasl2-bin'],
        ensure => 'present',
      }
    }
  }
  
  # install required packages
  package { 'postfix-install' :
    name => ['postfix'],
    ensure => present,
    require => Package['postfix-install-prereq'],
  }->
  
  # setup the config using our template
  file { 'postfix-config' :
    path => "${dopostfix::params::config_dir}/main.cf",
    content => template('dopostfix/main.cf.erb'),
    mode => '0644',
  }

  # if we're connecting to a secure relay server
  if ($smtp_auth) {
    # create and map SMTP AUTH password file
    file { 'postfix-sasl-password' :
      path => "${dopostfix::params::config_dir}/sasl_passwd",
      content => "[${smtp_hostname}] ${smtp_username}:${smtp_password}",
      mode => '0600',
      require => [File['postfix-config']],
    }->
    exec { 'postfix-sasl-passmap' :
      path => '/sbin:/usr/sbin',
      command => "postmap ${dopostfix::params::config_dir}/sasl_passwd",
      before => [Service['postfix']],
    }
  }
  
  # run the service now and at startup
  service { 'postfix':
    ensure    => running,
    enable    => true,
    require   => [Package['postfix-install']],
  }

  if (str2bool($::selinux)) {
    # allow the web server to send email
    exec { 'postfix-selinux-httpdcan' :
      path => '/usr/bin:/bin:/usr/sbin',
      command => 'setsebool -P httpd_can_sendmail 1',
    }
  }

}

