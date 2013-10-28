puppet-dopostfix
================

Devopera puppet module for setting up postfix

Changelog
---------

  * Added relay support and authenticated relay support

Usage
-----

Null sender setup
```
class { 'dopostfix' : }
```

Relay setup to named host on named port
```
class { 'dopostfix' :
  relay => true,
  smtp_auth => true,
  smtp_hostname => 'smtp.mandrillapp.com',
  smtp_username => 'username',
  smtp_password => 'password_or_API_key',
}
```

dopostfix will send mail out via the domain's mail server, found from the FQDN using its MX record unless:
1. force_restrict_relay => true, or
2. FQDN finishes .localdomain, or
3. relayhost != undef

Copyright and License
---------------------

Copyright (C) 2012 Lightenna Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
