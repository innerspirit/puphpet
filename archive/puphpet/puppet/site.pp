if $yaml_values == undef {
  $yaml_values = loadyaml('/vagrant/puphpet/config.yaml')
}

if $apache_values == undef {
  $apache_values = $yaml_values['apache']
}

if $beanstalkd_values == undef {
  $beanstalkd_values = hiera_hash('beanstalkd', false)
}

if $cron_values == undef {
  $cron_values = hiera_hash('cron', false)
}

if $drush_values == undef {
  $drush_values = hiera_hash('drush', false)
}

if $elasticsearch_values == undef {
  $elasticsearch_values = hiera_hash('elastic_search', false)
}

if $firewall_values == undef {
  $firewall_values = hiera_hash('firewall', false)
}

if $hhvm_values == undef {
  $hhvm_values = hiera_hash('hhvm', false)
}

if $mailcatcher_values == undef {
  $mailcatcher_values = hiera_hash('mailcatcher', false)
}

if $mariadb_values == undef {
  $mariadb_values = hiera_hash('mariadb', false)
}

if $mongodb_values == undef {
  $mongodb_values = hiera_hash('mongodb', false)
}

if $mysql_values == undef {
  $mysql_values = hiera_hash('mysql', false)
}

if $nginx_values == undef {
  $nginx_values = hiera_hash('nginx', false)
}

if $php_values == undef {
  $php_values = hiera_hash('php', false)
}

if $vm_values == undef {
  $vm_values = hiera_hash($::vm_target_key, false)
}

import 'nodes/*.pp'
