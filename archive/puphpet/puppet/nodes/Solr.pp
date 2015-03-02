if $solr_values == undef { $solr_values = hiera_hash('solr', false) }

include solr::params

if hash_key_equals($solr_values, 'install', 1) {
  $solr_settings = $solr_values['settings']

  exec { 'create solr conf dir':
    command => "mkdir -p ${solr::params::config_dir}",
    creates => $solr::params::config_dir,
    path    => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ],
  }

  if ! defined(Class['java']) {
    class { 'java':
      distribution => 'jre',
    }
  }

  $solr_version = $solr_settings['version']
  $solr_source_url = 'http://archive.apache.org/dist/lucene/solr'
  $solr_source_file = "${solr_version}/solr-${solr_version}.tgz"

  class { 'solr':
    install        => 'source',
    install_source => "${install_url}/${install_file}",
    require        => [
      Exec['create solr conf dir'],
      Class['java']
    ],
  }

  if ! defined(Firewall["100 tcp/${solr_settings['port']}"]) {
    firewall { "100 tcp/${solr_values['port']}":
      port   => $solr_values['port'],
      proto  => tcp,
      action => 'accept',
    }
  }

  $solr_destination = $solr::params::install_destination

  $solr_path = "${solr_destination}/solr-${solr_settings['version']}/bin"

  supervisord::program { 'solr':
    command     => "${solr_path}/solr start -p ${solr_settings['port']}",
    priority    => '100',
    user        => 'root',
    autostart   => true,
    autorestart => 'true',
    environment => {
      'PATH' => "/bin:/sbin:/usr/bin:/usr/sbin:${solr_path}"
    },
    require     => Class['solr'],
  }
}
