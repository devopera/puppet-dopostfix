class dopostfix (

) {
  # postfix module depends on puppi
  class { 'puppi':
    version => '2',
  }
  class { 'postfix':
    # source => [ "puppet:///modules/dopostfix/main.cf.erb" ],
    template => 'dopostfix/main.cf.erb',
  }

}

