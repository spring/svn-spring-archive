<?php

require_once($_SERVER['DOCUMENT_ROOT'] . '../configuration.php');

// phpBB 2.x auto-generated config file
// Do not change anything in this file!

$dbms = 'mysql4';

$dbhost = $site_configuration[sql_database][host];
$dbname = $site_configuration[sql_database][database_name];
$dbuser = $site_configuration[sql_database][user_name];
$dbpasswd = $site_configuration[sql_database][password];

$table_prefix = 'phpbb_';

define('PHPBB_INSTALLED', true);

?>
