<?php

if($page_name == 'index')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/index.css.php");
}
if($page_name == 'news')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/news.css.php");
}
if($page_name == 'wiki')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/wiki.css.php");
}
if($page_name == 'messageboard')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/messageboard.css.php");
}
if($page_name == 'about')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/about.css.php");
}
if($page_name == 'development')
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/development.css.php");
}


else
{
	include_once($cd."theme/".$site_theme."/css/header.css.php");
	include_once($cd."theme/".$site_theme."/css/index.css.php");
}

//	echo "<LINK REL=\"stylesheet\" MEDIA=\"screen\" TITLE=\"index\" TYPE=\"text/css\" HREF=\"theme/global/css/header.css\">\n";
//	echo "<LINK REL=\"stylesheet\" MEDIA=\"screen\" TITLE=\"index\" TYPE=\"text/css\" HREF=\"theme/".$site_theme."/css/index.css\">";
?>
