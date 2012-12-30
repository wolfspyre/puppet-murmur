# == Class: murmur::rhel::package
#  wrapper class
#
class murmur::rhel::package {
  Package{} -> Anchor['murmur::package::end']
  $packagename        = $murmur::packagename
  # end of variables
  case $murmur::ensure {
    present, enabled, active, disabled, stopped: {
      #everything should be installed
      package { $packagename:
        ensure => 'present',
      } -> Anchor['murmur::package::end']
    }#end present case
    absent: {
      #everything should be removed
      package { $packagename:
        ensure => 'absent',
      } -> Anchor['murmur::package::end']
    }#end absent case
    default: {
      notice "murmur::ensure has an unsupported value of ${murmur::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
