define tomcat7_r2::install(	$java_home,
				$tomcat_env,
				$tomcat_partition,
				$tomcat_path,
							$tomcat_package,
							$tomcat_home,
							$tomcat_user,
							$tomcat_memory_heap,
							$tomcat_jvm_params,
							$tomcat_initd,
							$tomcat_port_jmx,
							$tomcat_port_shutdown,
							$tomcat_port_ajp,
							$tomcat_port_ssl,
							$tomcat_port_http,
							$tomcat_project){
 
 file {"${tomcat_path}":
   path   => "${tomcat_path}",
   ensure => directory,
 }
		
 file {"${tomcat_path}/${tomcat_package}":
   path    => "${tomcat_path}/${tomcat_package}",
   ensure  => present,
   owner   => "${tomcat_user}",
   source  => "puppet:///modules/tomcat7_r2/${tomcat_package}",
   mode    => '0755',
   replace => true,
   require => File["${tomcat_path}"],
 }

 exec {"Install_tomcat_${title}":
   path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
   cwd     => "${tomcat_path}",
   command => "tar -xzvf ${tomcat_package} && rm -f ${tomcat_package} && chmod 755 ${tomcat_path} && chmod 755 ${tomcat_home} && chown -R ${tomcat_user}. ${tomcat_path}",
   creates => "${tomcat_home}/LICENSE",
   require => File["${tomcat_path}/${tomcat_package}"],
 }

 file {"/etc/init.d/${tomcat_initd}":
    ensure  => present,
    content => template("tomcat7_r2/tomcat.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    replace => true,
    require => Exec["Install_tomcat_${title}"],
  }

if $tomcat_project == false {
  	file {"${tomcat_home}/bin/catalina.sh":
    		ensure  => present,
    		content => template("tomcat7_r2/catalina.sh.erb"),
    		owner   => "${tomcat_user}",
    		group   => "${tomcat_user}",
    		mode    => '0755',
    		replace => true,
    		require => File["/etc/init.d/${tomcat_initd}"],
  	}

  	file {"${tomcat_home}/conf/server.xml":
    		ensure  => present,
    		content => template("tomcat7_r2/server.xml.erb"),
    		owner   => "${tomcat_user}",
    		group   => "${tomcat_user}",
    		mode    => '0755',
    		replace => true,
    		require => File["${tomcat_home}/bin/catalina.sh"], 
  	}

  	tomcat7_r2::service{"aplica_permissao_${title}":
		tomcat_path		=> "${tomcat_path}",
		tomcat_user		=> "${tomcat_user}",
		require			=> File["${tomcat_home}/conf/server.xml"],
 	}
}

 
}
