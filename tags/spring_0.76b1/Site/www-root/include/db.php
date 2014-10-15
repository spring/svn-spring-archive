<?php
$spring_db = new mysqli($site_configuration[sql_database][host], $site_configuration[sql_database][user_name], $site_configuration[sql_database][password], $site_configuration[sql_database][database_name]);
if (mysqli_connect_errno()) { exit("MySQL connection error, code: ". mysqli_connect_error()); }
if (!$spring_db->set_charset("utf8")) {	printf("Error loading character set utf8: %s\n", $spring_db->error); exit(); }
?>
