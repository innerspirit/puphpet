if $yaml_values == undef {
  $yaml_values = loadyaml('/vagrant/puphpet/config.yaml')
}

if $apache_values == undef {
  $apache_values = $yaml_values['apache']
}

if $beanstalkd_values == undef {
  $beanstalkd_values = hiera_hash('beanstalkd', false)
}

if $hhvm_values == undef {
  $hhvm_values = hiera_hash('hhvm', false)
}

if $nginx_values == undef {
  $nginx_values = hiera_hash('nginx', false)
}

if $php_values == undef {
  $php_values = hiera_hash('php', false)
}

import 'nodes/*.pp'
