if $yaml_values == undef {
  $yaml_values = loadyaml('/vagrant/puphpet/config.yaml')
}
if $apache_values == undef {
  $apache_values = $yaml_values['apache']
}
if $php_values == undef {
  $php_values = hiera_hash('php', false)
}
if $hhvm_values == undef {
  $hhvm_values = hiera_hash('hhvm', false)
}

import 'nodes/*.pp'
