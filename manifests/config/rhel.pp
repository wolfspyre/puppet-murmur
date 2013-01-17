# == Class: ganglia::rhel::config
#  wrapper class
#
#
Anchor['ganglia::package::end'] -> Class['ganglia::rhel::config']
class ganglia::rhel::config {
  #make our parameters local scope
  File{} -> Anchor['ganglia::config::end']
  #clean up our parameters
  $ensure             = $ganglia::ensure
  case $ensure {
    present, enabled, active, disabled, stopped: {
      #everything should be installed

    }#end configfiles should be present case
    absent: {

    }#end configfiles should be absent case
    default: {
      notice "ganglia::ensure has an unsupported value of ${ganglia::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
