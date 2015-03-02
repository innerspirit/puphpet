include puphpet::params
include puphpet::supervisord

if hash_key_equals($mailcatcher_values, 'install', 1) {
  if ! defined(Package['tilt']) {
    package { 'tilt':
      ensure   => '1.3',
      provider => 'gem',
      before   => Class['mailcatcher']
    }
  }

  if $::operatingsystem == 'ubuntu' and $lsbdistcodename == 'trusty' {
    package { 'rubygems':
      ensure => absent,
    }
  }

  $mailcatcher_settings = delete(
    $mailcatcher_values['settings'],
    'from_email_method'
  )

  create_resources('class', { 'mailcatcher' => $mailcatcher_settings })

  $mailcatcher_smtp_port = $mailcatcher_settings['smtp_port']
  $mailcatcher_http_port = $mailcatcher_settings['http_port']
  $mailcatcher_firewall_port =
    "100 tcp/${mailcatcher_smtp_port}, ${mailcatcher_http_port}"

  if ! defined(Firewall[$mailcatcher_firewall_port]) {
    firewall { $mailcatcher_firewall_port:
      port   => [$mailcatcher_smtp_port, $mailcatcher_http_port],
      proto  => tcp,
      action => 'accept',
    }
  }

  $mailcatcher_path = $mailcatcher_settings['mailcatcher_path']

  $mailcatcher_options = sort(join_keys_to_values({
    ' --smtp-ip'   => $mailcatcher_settings['smtp_ip'],
    ' --smtp-port' => $mailcatcher_settings['smtp_port'],
    ' --http-ip'   => $mailcatcher_settings['http_ip'],
    ' --http-port' => $mailcatcher_settings['http_port']
  }, ' '))

  supervisord::program { 'mailcatcher':
    command     => "${mailcatcher_path}/mailcatcher ${mailcatcher_options} -f",
    priority    => '100',
    user        => 'mailcatcher',
    autostart   => true,
    autorestart => 'true',
    environment => {
      'PATH' => "/bin:/sbin:/usr/bin:/usr/sbin:${mailcatcher_path}"
    },
    require     => [
      Class['mailcatcher::config'],
      File['/var/log/mailcatcher']
    ],
  }
}
