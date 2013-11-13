class dopostfix::monitor (

  # class arguments
  # ---------------
  # setup defaults
  
  # end of class arguments
  # ----------------------
  # begin class

) {

  # check that postfix is running as a service
  @nagios::service { "int:process_postfix-dopostfix-${::fqdn}":
    check_command => "check_procs!1:!1:!'postfix'",
  }

}
