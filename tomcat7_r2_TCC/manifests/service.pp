define tomcat7_r2::service(	$tomcat_path,
				$tomcat_user){
  exec {"${title}":
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    cwd     => "$tomcat_path",
    provider => shell,
    #onlyif  => "if [ $(find ${tomcat_path} ! -user ${tomcat_user} | wc -l) -gt 0 ]; then true; else false; fi",
    command => "find ${tomcat_path} ! -user ${tomcat_user} -exec chown ${tomcat_user}. {} \;",
 }
}

