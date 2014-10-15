<?php
/* 
* Spring Site configuration file
*
* This is an example, copy to configuration.php to make a local copy with real passwords.
*
*/

// Database values
$site_configuration[sql_database][host] = "localhost";
$site_configuration[sql_database][database_name] = "spring";
$site_configuration[sql_database][user_name] = "spring_user";
$site_configuration[sql_database][password] = "password";

/*
** News system configuration.
*/

$site_configuration[news][forum_id][project_news] = (int)0;
$site_configuration[news][forum_id][community_news] = (int)0;
$site_configuration[news][forum_id][highlight] = (int)0;

/*
** Translation system configuration.
*/

// Default site language.
$site_configuration[language][default_language] = 'English';

// Language mapping for autodetection.
$site_configuration[language][map][English] = array('en', 'en-gb', 'en-au', 'en-us');
$site_configuration[language][map][Dutch] = array('nl', 'nl-be');
$site_configuration[language][map][French] = array('fr', 'fr-be', 'fr-ca', 'fr-lu', 'fr-ch');
$site_configuration[language][map][German] = array('de', 'de-de', 'de-lu', 'de-li', 'de-at', 'de-ch');
$site_configuration[language][map][Spanish] = array('es-mx', 'es-co', 'es-ar', 'es-cl', 'es-pr', 'es');
$site_configuration[language][map][Swedish] = array('sv', 'sv-fi');
$site_configuration[language][map][Portugese] = array('pt', 'pt-br');
$site_configuration[language][map][Italian] = array('it', 'it-ch');
$site_configuration[language][map][Russian] = array('ru-mo', 'ru-ru', 'ru-ua', 'ru');
$site_configuration[language][map][Romanian] = array('ro-mo', 'ro');
$site_configuration[language][map][Chinese_simplified] = array('zh-cn', 'zh-sg', 'zh');
$site_configuration[language][map][Chinese_traditional] = array('zh-hk', 'zh-tw');
$site_configuration[language][map][Japanese] = array('ja');
$site_configuration[language][map][Korean] = array('ko');
$site_configuration[language][map][Finnish] = array('fi');
$site_configuration[language][map][Polish] = array('pl');
$site_configuration[language][map][Norwegian] = array('no');
$site_configuration[language][map][Danish] = array('da');
$site_configuration[language][map][Bulgarian] = array('bg');
$site_configuration[language][map][Catalan] = array('ca');
$site_configuration[language][map][Czech] = array('cs');
$site_configuration[language][map][Estonian] = array('et');
$site_configuration[language][map][Hungarian] = array('hu');
$site_configuration[language][map][Croatian] = array('hr');
$site_configuration[language][map][Icelandic] = array('is');
$site_configuration[language][map][Lithuanian] = array('lt');
$site_configuration[language][map][Latvian] = array('lv');
$site_configuration[language][map][Serbian] = array('sr');
$site_configuration[language][map][Slovak] = array('sk');
$site_configuration[language][map][Slovene] = array('sl');
$site_configuration[language][map][Turkish] = array('tr');
$site_configuration[language][map][Ukrainian] = array('uk');

// Special languages that have to be excluded here and there.
$site_configuration[language][special][translation] = array('Empty');
$site_configuration[language][special][header_menu] = array('Development', 'Empty', 'Funny1', 'Funny2', 'Funny3', 'Testing1', 'Testing2', 'Testing3');

?>
