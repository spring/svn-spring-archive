<?php
$spring_db = mysql_connect($site_configuration[sql_database][host], $site_configuration[sql_database][user_name], $site_configuration[sql_database][password]);
mysql_select_db($site_configuration[sql_database][database_name]);
?>
