class tomcat7_r2(
    $tomcat_user           = $tomcat7_r2::params::tomcat_user,
    $tomcat_partition      = $tomcat7_r2::params::tomcat_partition,
    $java_home             = $tomcat7_r2::params::java_home,

	$service_name          = $tomcat7_r2::params::service_name,
    $service_enable        = $tomcat7_r2::params::service_enable,
    $service_ensure        = $tomcat7_r2::params::service_ensure,
    $service_status        = $tomcat7_r2::params::service_status,
    $service_restart       = $tomcat7_r2::params::service_restart,
    $java_opts             = $tomcat7_r2::params::java_opts,
    $memcached_host        = $tomcat7_r2::params::memcached_host,
	$svn_path 	       = $tomcat7_r2::params::svn_path,	
	$project               = $tomcat7_r2::params::project,
	$project_name          = $tomcat7_r2::params::project_name,
    $env		       = $tomcat7_r2::params::env,
    $url_view             = $tomcat7_r2::params::url_view,
    $url_salesportal       = $tomcat7_r2::params::url_salesportal,
    $orgcrmenv           = $tomcat7_r2::params::orgcrmenv,
    $connector_proxyname   = $tomcat7_r2::params::connector_proxyname,
    $toa_hostname          = $tomcat7_r2::params::toa_hostname,
    $toa_username          = $tomcat7_r2::params::toa_username,
    $toa_password          = $tomcat7_r2::params::toa_password,

       ### variables projeto COM
        $orgcomenv           = $tomcat7_r2::params::orgcomenv,
        $idp_endpoint          = $tomcat7_r2::params::idp_endpoint,
		$idp_endpoint_port_ws  = $tomcat7_r2::params::idp_endpoint_port_ws,
        $callback_url	       = $tomcat7_r2::params::callback_url,
        $filter_user           = $tomcat7_r2::params::filter_user,
        $filter_role           = $tomcat7_r2::params::filter_role,
        $limit                 = $tomcat7_r2::params::limit,
        $idp_user              = $tomcat7_r2::params::idp_user,
        $idp_password          = $tomcat7_r2::params::idp_password,
        $subject_prefix        = $tomcat7_r2::params::subject_prefix,
        $database_url          = $tomcat7_r2::params::database_url,
        $database_user         = $tomcat7_r2::params::database_user,
        $database_password     = $tomcat7_r2::params::database_password,
        $database_maxpool_size = $tomcat7_r2::params::database_maxpool_size,
        $jpa_database          = $tomcat7_r2::params::jpa_database,
        $jpa_showsql           = $tomcat7_r2::params::jpa_showsql)inherits tomcat7_r2::params {

# include tomcat7::install
# include tomcat7::service
        
# if $project == true {
#   include "tomcat7_r2::$project_name"
# }
 user {"${tomcat_user}":
   ensure     => present,
   home       => "${tomcat_partition}",
   managehome => true,
 }
 
}
