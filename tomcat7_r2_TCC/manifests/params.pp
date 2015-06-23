class tomcat7_r2::params {
	$tomcat_user = "tomcat" 
	$java_opts = "-Xms512m -Xmx1000m -XX:MaxPermSize=256M -XX:PermSize=128M"
	$tomcat_partition = "/tomcat"	
	$java_home = "/opt/java"
        $env = undef
}
