define tomcat7_r2::envconf(	$tomcat_envconf_project_name,
				$tomcat_envconf_project_subname,
				$tomcat_envconf_directory,
				$tomcat_envconf_file,
				$tomcat_envconf_home,
				$tomcat_envconf_env,
				$tomcat_envconf_user,
				$tomcat_envconf_recursive_copy,
				$tomcat_envconf_partition) {
	
	if $tomcat_envconf_recursive_copy == true {
		file {"${tomcat7::tomcat_home}":
   			#source  => "puppet:///modules/projetos/${tomcat_envconf_project}/${tomcat_envconf_subproject}.erb",
   			source  => "puppet:///modules/tomcat7/tomcat",
   			recurse => remote,
   			links   => follow,
   			owner   => "${tomcat_envconf_user}",
   			group   => "${tomcat_envconf_user}",
			replace	=> true,
   			ignore  => ".svn",
 		}
		tomcat7_r2::service{"apply_permission_recursive_copy_$title":
        		tomcat_path             => "${tomcat_envconf_partition}",
        		tomcat_user             => "${tomcat_envconf_user}",
 		}
	}

	if ($tomcat_envconf_directory != '' and $tomcat_envconf_home != '' and $tomcat_envconf_file !=  '') {
		file {"${tomcat_envconf_home}/${tomcat_envconf_directory}/${tomcat_envconf_file}":
			ensure	=> present,
			owner	=> "${tomcat_envconf_user}",
			group	=> "${tomcat_envconf_user}",
			mode	=> '755',
			replace	=> true,
			content	=> template("tomcat7_r2/projetos/${tomcat_envconf_project_name}/${tomcat_envconf_project_subname}/${tomcat_envconf_env}/${tomcat_envconf_directory}/${tomcat_envconf_file}.erb"),
		}
		tomcat7_r2::service{"apply_permission_envconf_$title":
        		tomcat_path             => "${tomcat_envconf_partition}",
        		tomcat_user             => "${tomcat_envconf_user}",
 		}
	}
	
}
