# == Class: murmur::rhel::service
#  wrapper class
Anchor['murmur::config::end'] -> Class['murmur::rhel::service']
class murmur::rhel::service {
  Service{} -> Anchor['murmur::service::end']
  # end of variables
  case $murmur::ensure {
    enabled, active: {
      #everything should be installed, but puppet is not managing the state of the service
      service {'murmur':
        ensure    => running,
        enable    => true,
        subscribe => File['murmur_conf'],
        require   => Package['Murmur'],
        hasstatus => true,
      }#end service definition
    }#end enabled class
    disabled, stopped: {
      service {'murmur':
        ensure    => stopped,
        enable    => false,
        subscribe => File['murmur_conf'],
        hasstatus => true,
      }#end service definition
    }#end disabled
    default: {
      #nothing to do, puppet shouldn't care about the service
    }#end default ensure case
  }#end ensure case
}#end class
