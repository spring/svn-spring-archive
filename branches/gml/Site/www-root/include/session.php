<?php

require_once($_SERVER['DOCUMENT_ROOT'] . '/../configuration.php');
require_once('include/db.php');
require_once("include/classes.php");

session_start();
site_theme::set_session_theme();
site_language::set_session_language();
site_language::get_page();

?>
