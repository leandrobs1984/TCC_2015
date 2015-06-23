define tomcat7_r2::deploy(	$package_name,
							$env,
							$server_hostname,
							$project_name,
							$deploy_user,
							$repo_jenkins_baseurl,
							$tomcat_initd,
							$tomcat_home,
							$tomcat_port_http){
   include tomcat7_r2::params
   $tomcat_user		= $tomcat7_r2::params::tomcat_user
							
   case $::osfamily {
    'Debian': {
      $yum_path   = '/bin/'
    }
    'RedHat': {
      $yum_path      = '/usr/bin/'
    }
   }

 yumrepo {"${project_name}_${title}_base":
    baseurl  => "http://${repo_jenkins_baseurl}.network.com/${env}/Centos/6/$::architecture",
    descr    => "Pacote referente ao projeto ${project_name} -> ${title}",
    enabled  => 1,
    gpgcheck => 0,
 }

 exec { "${title}_remove_package_rpm":
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "rpm -e ${package_name}",
    onlyif  => "rpm -qa | grep ${package_name}",
    require =>  Yumrepo["${project_name}_${title}_base"],
 }

file_line{ 
    "${title}_visudo_user":
    	ensure => present,
    	path   => "/etc/sudoers",
    	line   => "${deploy_user} ALL=NOPASSWD:${yum_path}yum *",
    	require => Exec["${title}_remove_package_rpm"];
   "${title}_visudo_requiretty":
   	ensure => present,
   	path   => "/etc/sudoers",
   	line   => "#Defaults    requiretty",
   	match  => "Defaults    requiretty",
    	require =>Exec["${title}_remove_package_rpm"], 
 }

 file {"${title}_kill_tomcat":
   path    => "${tomcat_home}/kill_tomcat.sh",
   ensure  => present,
   owner   => "${tomcat_user}",
   group   => "${tomcat_user}",
   source  => "puppet:///modules/tomcat7_r2/kill_tomcat.sh",
   mode    => '0755',
   replace => true,
   require => File_line["${title}_visudo_user","${title}_visudo_requiretty"],
 }
 
exec {"${title}_shutting_down_tomcat":
   path     => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   command  => "sh ${tomcat_home}/kill_tomcat.sh ${tomcat_home} && rm -f ${tomcat_home}/kill_tomcat.sh",
   provider => shell,
   require  => File["${title}_kill_tomcat"],
 }

exec {"${title}_deleting_conflicting_files":
   path     => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   command  => "rm -rf ${tomcat_home}/webapps/${title}/",
   require  => Exec["${title}_shutting_down_tomcat"],
 }
 
exec {"${title}_deleting_temporary_files":
   path     => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   command  => "rm -rf ${tomcat_home}/temp /tomcat/tomcat/temp.felix-cache",
   require  => Exec["${title}_deleting_conflicting_files"],
 }
 
exec {"${title}_deleting_work_files":
   path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   command => "rm -rf ${tomcat_home}/work/",
   require => Exec["${title}_deleting_temporary_files"],
 }

 exec { "${title}_yum_clean_all":
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => 'yum clean all',
    require  => Exec["${title}_deleting_work_files"],
 }

 exec { "${title}_yum_install_package":
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    command => "sudo ${yum_path}yum --disablerepo=* --enablerepo=${project_name}_${title}_base -y install ${package_name}",
    user    => "${deploy_user}",
    require => Exec["${title}_yum_clean_all"],
 }

 service {"${tomcat_initd}":
   ensure    => running,
   enable    => true,
   require   => Exec["${title}_yum_install_package"],
 }
 
 exec {"${title}_waiting_for_tomcat":
   path     => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   command  => "i=0;while true; do curl --max-time 1 --connect-timeout 1 localhost:${tomcat_port_http} -w '%{response_code}' -so /dev/null | grep '200' &>/dev/null; if [ $? -eq 0 ];then break; fi ; sleep 5;done",
   provider => shell,
   require  => Service["${tomcat_initd}"],
 }

}
