<?php
	// Load the global config file.
	require_once($_SERVER['DOCUMENT_ROOT'] . '/../configuration.php');

  $g_db_type = 'mysql';
  $g_hostname = $site_configuration[sql_database][host];
  $g_database_name = $site_configuration[sql_database][database_name];
  $g_db_username = $site_configuration[sql_database][user_name];
  $g_db_password = $site_configuration[sql_database][password];

  $g_administrator_email = 'fnordia@clan-sy.com';
  $g_webmaster_email = '';
  $g_from_email = 'spring-noreply@clan-sy.com';
  $g_return_path_email = 'spring-noreply@clan-sy.com';

  $g_notify_new_user_created_threshold_min = NOBODY;
  $g_password_confirm_hash_magic_string = '1?2?3?';

  $g_allow_anonymous_login	= ON;
  $g_anonymous_account		= 'Anonymous';
?>
