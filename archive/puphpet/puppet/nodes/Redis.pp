include puphpet::params

if hash_key_equals($apache_values, 'install', 1)
  or hash_key_equals($nginx_values, 'install', 1)
{
  $redis_webserver_restart = true
} else {
  $redis_webserver_restart = false
}

if hash_key_equals($redis_values, 'install', 1) {
  create_resources('class', { 'redis' => $redis_values['settings'] })

  if hash_key_equals($php_values, 'install', 1)
    and ! defined(Puphpet::Php::Pecl['redis'])
  {
    puphpet::php::pecl { 'redis':
      service_autorestart => $redis_webserver_restart,
      require             => Class['redis']
    }
  }
}
