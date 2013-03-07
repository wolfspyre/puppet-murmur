# == Class: murmur::rhel::config
#  wrapper class
#
#  iptables rule should we ever decide to add iptables rules automagically:
#      -A RH-Firewall-1-INPUT -p tcp -m tcp --dport murmurport -j ACCEPT
#      -A RH-Firewall-1-INPUT -p udp -m udp --dport murmurport -j ACCEPT
#
class murmur::rhel::config {
Anchor['murmur::package::end'] -> Class['murmur::rhel::config']
  #make our parameters local scope
  File{} -> Anchor['murmur::config::end']
  #clean up our parameters
  $ensure             = $murmur::ensure
  $allowhtml          = $murmur::allowhtml
  $autoban_attempts   = $murmur::autoban_attempts
  $autoban_timeframe  = $murmur::autoban_timeframe
  $autoban_time       = $murmur::autoban_time
  $bandwidth          = $murmur::bandwidth
  $configfile         = $murmur::configfile
  $configfilepath     = "$murmur::installdir$murmur::configfile"
  $database           = $murmur::database
  $host               = $murmur::host
  $imagemessagelength = $murmur::imagemessagelength
  $installdir         = $murmur::installdir
  $logdays            = $murmur::logdays
  $logfile            = $murmur::logfile
  $logrotate          = $murmur::logrotate
  $pidfile            = $murmur::pidfile
  $port               = $murmur::port
  $rpc                = $murmur::rpc
  $serverpassword     = $murmur::serverpassword
  $sslcert            = $murmur::sslcert
  $sslkey             = $murmur::sslkey
  $textmessagelength  = $murmur::textmessagelength
  $users              = $murmur::users
  $uname              = $murmur::uname
  $welcometext        = $murmur::welcometext
  case $ensure {
    present, enabled, active, disabled, stopped: {
      #everything should be installed
      file {'murmur_conf':
        ensure  => 'present',
        path    =>  $configfilepath,
        owner   => 'murmur',
        group   => 'murmur',
        mode    => '0440',
        content => template('murmur/usr/local/murmur/murmur.ini.erb'),
        require => Package['Murmur'],
      }#end murmur_conf file
      file {'murmur_logfile':
        ensure  => 'present',
        path    => $logfile,
        owner   => 'murmur',
        group   => 'murmur',
        mode    => '0664',
        require => Package['Murmur'],
      }#end murmur logfile file

      file {'/usr/local/murmur':
        ensure  => 'directory',
        owner   => 'murmur',
        group   => 'murmur',
        require => Package['Murmur'],
        mode    => '0755',
      }#End murmur dir

      file {'/etc/init.d/murmur':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => "puppet:///modules/${module_name}/etc/murmur",
        require => Package['Murmur'],
      }#End init file
      #logrotate
      if $logrotate {
        include logrotate
        logrotate::file{ 'murmur_log':
          log     => $logfile,
          options => ['weekly','rotate 1','compress'],
        }
      }

    }#end configfiles should be present case
    absent: {
      file {'murmur_conf':
        ensure  => 'absent',
        path    =>  $configfilepath,
      }#end murmurd.conf file
      file {'/etc/init.d/murmur':
        ensure => 'absent',
      }#End init file
      file {'/usr/local/ventsrv':
        ensure => 'absent',
        force  => true,
      }#end murmurdir
      file {'murmur_logfile':
        ensure  => 'absent',
        path    => $logfile,
      }#end murmur logfile file

    }#end configfiles should be absent case
    default: {
      notice "murmur::ensure has an unsupported value of ${murmur::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
