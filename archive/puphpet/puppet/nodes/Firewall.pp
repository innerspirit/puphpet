include puphpet::params

Firewall {
  before  => Class['puphpet::firewall::post'],
  require => Class['puphpet::firewall::pre'],
}

class { ['puphpet::firewall::pre', 'puphpet::firewall::post']: }

class { 'firewall': }

if is_hash($firewall_values['rules'])
  and count($firewall_values['rules']) > 0
{
  each( $firewall_values['rules'] ) |$key, $rule| {
    $firewall_rule = "${rule['priority']} ${rule['proto']}/${rule['port']}"

    if ! defined(Firewall[$firewall_rule]) {
      firewall { $firewall_rule:
        port   => $rule['port'],
        proto  => $rule['proto'],
        action => $rule['action'],
      }
    }
  }
}

if has_key($vm_values, 'ssh')
  and has_key($vm_values['ssh'], 'port')
{
  $vm_values_ssh_port = $vm_values['ssh']['port'] ? {
    ''      => 22,
    undef   => 22,
    0       => 22,
    default => $vm_values['ssh']['port']
  }

  if ! defined(Firewall["100 tcp/${vm_values_ssh_port}"]) {
    firewall { "100 tcp/${vm_values_ssh_port}":
      port   => $vm_values_ssh_port,
      proto  => tcp,
      action => 'accept',
      before => Class['puphpet::firewall::post']
    }
  }
}

if has_key($vm_values, 'vm')
  and has_key($vm_values['vm'], 'network')
  and has_key($vm_values['vm']['network'], 'forwarded_port')
{
  $firewall_forwarded_port = $vm_values['vm']['network']['forwarded_port']
  create_resources( puphpet::firewall::port, $firewall_forwarded_port )
}
