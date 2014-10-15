-- Some example SQL for the website, intended for an installation of the site on you own system.
-- Create a MySQL database and import this file into it, then alter/create a configuration.php file in the parent directory of www-root.
-- Note that this includes example Mediawiki, Mantis and PhpBB2 data, some site translation data is also included.

-- phpMyAdmin SQL Dump
-- version 2.10.3deb1
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generatie Tijd: 25 Oct 2007 om 23:24
-- Server versie: 5.0.45
-- PHP Versie: 5.2.3-1ubuntu6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

-- 
-- Database: `spring`
-- 

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bugnote_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bugnote_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `bug_id` int(10) unsigned NOT NULL default '0',
  `reporter_id` int(10) unsigned NOT NULL default '0',
  `bugnote_text_id` int(10) unsigned NOT NULL default '0',
  `view_state` smallint(6) NOT NULL default '10',
  `date_submitted` datetime NOT NULL default '1970-01-01 00:00:01',
  `last_modified` datetime NOT NULL default '1970-01-01 00:00:01',
  `note_type` int(11) default '0',
  `note_attr` varchar(250) default '',
  PRIMARY KEY  (`id`),
  KEY `idx_bug` (`bug_id`),
  KEY `idx_last_mod` (`last_modified`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bugnote_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bugnote_text_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bugnote_text_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `note` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bugnote_text_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_file_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_file_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `bug_id` int(10) unsigned NOT NULL default '0',
  `title` varchar(250) NOT NULL default '',
  `description` varchar(250) NOT NULL default '',
  `diskfile` varchar(250) NOT NULL default '',
  `filename` varchar(250) NOT NULL default '',
  `folder` varchar(250) NOT NULL default '',
  `filesize` int(11) NOT NULL default '0',
  `file_type` varchar(250) NOT NULL default '',
  `date_added` datetime NOT NULL default '1970-01-01 00:00:01',
  `content` longblob NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `idx_bug_file_bug_id` (`bug_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_file_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_history_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_history_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `bug_id` int(10) unsigned NOT NULL default '0',
  `date_modified` datetime NOT NULL default '1970-01-01 00:00:01',
  `field_name` varchar(32) NOT NULL default '',
  `old_value` varchar(128) NOT NULL default '',
  `new_value` varchar(128) NOT NULL default '',
  `type` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `idx_bug_history_bug_id` (`bug_id`),
  KEY `idx_history_user_id` (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_history_table`
-- 

INSERT INTO `mantis_bug_history_table` (`id`, `user_id`, `bug_id`, `date_modified`, `field_name`, `old_value`, `new_value`, `type`) VALUES 
(1, 1, 1, '2007-10-25 23:20:07', '', '', '', 1),
(2, 7, 2, '2007-10-25 23:21:49', '', '', '', 1);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_monitor_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_monitor_table` (
  `user_id` int(10) unsigned NOT NULL default '0',
  `bug_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`user_id`,`bug_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_monitor_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_relationship_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_relationship_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `source_bug_id` int(10) unsigned NOT NULL default '0',
  `destination_bug_id` int(10) unsigned NOT NULL default '0',
  `relationship_type` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `idx_relationship_source` (`source_bug_id`),
  KEY `idx_relationship_destination` (`destination_bug_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_relationship_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `project_id` int(10) unsigned NOT NULL default '0',
  `reporter_id` int(10) unsigned NOT NULL default '0',
  `handler_id` int(10) unsigned NOT NULL default '0',
  `duplicate_id` int(10) unsigned NOT NULL default '0',
  `priority` smallint(6) NOT NULL default '30',
  `severity` smallint(6) NOT NULL default '50',
  `reproducibility` smallint(6) NOT NULL default '10',
  `status` smallint(6) NOT NULL default '10',
  `resolution` smallint(6) NOT NULL default '10',
  `projection` smallint(6) NOT NULL default '10',
  `category` varchar(64) NOT NULL default '',
  `date_submitted` datetime NOT NULL default '1970-01-01 00:00:01',
  `last_updated` datetime NOT NULL default '1970-01-01 00:00:01',
  `eta` smallint(6) NOT NULL default '10',
  `bug_text_id` int(10) unsigned NOT NULL default '0',
  `os` varchar(32) NOT NULL default '',
  `os_build` varchar(32) NOT NULL default '',
  `platform` varchar(32) NOT NULL default '',
  `version` varchar(64) NOT NULL default '',
  `fixed_in_version` varchar(64) NOT NULL default '',
  `build` varchar(32) NOT NULL default '',
  `profile_id` int(10) unsigned NOT NULL default '0',
  `view_state` smallint(6) NOT NULL default '10',
  `summary` varchar(128) NOT NULL default '',
  `sponsorship_total` int(11) NOT NULL default '0',
  `sticky` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `idx_bug_sponsorship_total` (`sponsorship_total`),
  KEY `idx_bug_fixed_in_version` (`fixed_in_version`),
  KEY `idx_bug_status` (`status`),
  KEY `idx_project` (`project_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_table`
-- 

INSERT INTO `mantis_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `category`, `date_submitted`, `last_updated`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`) VALUES 
(1, 1, 1, 0, 0, 30, 50, 10, 10, 10, 10, '', '2007-10-25 23:20:07', '2007-10-25 23:20:07', 10, 1, '', '', '', '', '', '', 0, 10, 'Bug1', 0, 0),
(2, 1, 7, 0, 0, 30, 20, 90, 10, 10, 10, '', '2007-10-25 23:21:49', '2007-10-25 23:21:49', 10, 2, '', '', '', '', '', '', 0, 10, 'Let''s get bug nr. 2 in there to!', 0, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_bug_text_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_bug_text_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `description` text NOT NULL,
  `steps_to_reproduce` text NOT NULL,
  `additional_information` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_bug_text_table`
-- 

INSERT INTO `mantis_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES 
(1, 'This is bug nr. 1 and it''s quite a simple bug actually, it''s so simple to that you best just ignore it and move on to more important things.', '', 'Additional information?? Did I not make sence in the description field?'),
(2, 'Don''t "bug" me so much. :-D', '', '');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_config_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_config_table` (
  `config_id` varchar(64) NOT NULL default '',
  `project_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `access_reqd` int(11) default '0',
  `type` int(11) default '90',
  `value` text NOT NULL,
  PRIMARY KEY  (`config_id`,`project_id`,`user_id`),
  KEY `idx_config` (`config_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_config_table`
-- 

INSERT INTO `mantis_config_table` (`config_id`, `project_id`, `user_id`, `access_reqd`, `type`, `value`) VALUES 
('database_version', 0, 0, 90, 1, '51'),
('allow_reporter_close', 6, 0, 90, 1, '1'),
('reopen_bug_threshold', 6, 0, 90, 1, '55');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_custom_field_project_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_custom_field_project_table` (
  `field_id` int(11) NOT NULL default '0',
  `project_id` int(10) unsigned NOT NULL default '0',
  `sequence` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`field_id`,`project_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_custom_field_project_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_custom_field_string_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_custom_field_string_table` (
  `field_id` int(11) NOT NULL default '0',
  `bug_id` int(11) NOT NULL default '0',
  `value` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`field_id`,`bug_id`),
  KEY `idx_custom_field_bug` (`bug_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_custom_field_string_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_custom_field_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_custom_field_table` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `type` smallint(6) NOT NULL default '0',
  `possible_values` varchar(255) NOT NULL default '',
  `default_value` varchar(255) NOT NULL default '',
  `valid_regexp` varchar(255) NOT NULL default '',
  `access_level_r` smallint(6) NOT NULL default '0',
  `access_level_rw` smallint(6) NOT NULL default '0',
  `length_min` int(11) NOT NULL default '0',
  `length_max` int(11) NOT NULL default '0',
  `advanced` tinyint(4) NOT NULL default '0',
  `require_report` tinyint(4) NOT NULL default '0',
  `require_update` tinyint(4) NOT NULL default '0',
  `display_report` tinyint(4) NOT NULL default '1',
  `display_update` tinyint(4) NOT NULL default '1',
  `require_resolved` tinyint(4) NOT NULL default '0',
  `display_resolved` tinyint(4) NOT NULL default '0',
  `display_closed` tinyint(4) NOT NULL default '0',
  `require_closed` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `idx_custom_field_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_custom_field_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_filters_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_filters_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `project_id` int(11) NOT NULL default '0',
  `is_public` tinyint(4) default NULL,
  `name` varchar(64) NOT NULL default '',
  `filter_string` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_filters_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_news_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_news_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `project_id` int(10) unsigned NOT NULL default '0',
  `poster_id` int(10) unsigned NOT NULL default '0',
  `date_posted` datetime NOT NULL default '1970-01-01 00:00:01',
  `last_modified` datetime NOT NULL default '1970-01-01 00:00:01',
  `view_state` smallint(6) NOT NULL default '10',
  `announcement` tinyint(4) NOT NULL default '0',
  `headline` varchar(64) NOT NULL default '',
  `body` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_news_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_category_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_category_table` (
  `project_id` int(10) unsigned NOT NULL default '0',
  `category` varchar(64) NOT NULL default '',
  `user_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`project_id`,`category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_category_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_file_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_file_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `project_id` int(10) unsigned NOT NULL default '0',
  `title` varchar(250) NOT NULL default '',
  `description` varchar(250) NOT NULL default '',
  `diskfile` varchar(250) NOT NULL default '',
  `filename` varchar(250) NOT NULL default '',
  `folder` varchar(250) NOT NULL default '',
  `filesize` int(11) NOT NULL default '0',
  `file_type` varchar(250) NOT NULL default '',
  `date_added` datetime NOT NULL default '1970-01-01 00:00:01',
  `content` longblob NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_file_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_hierarchy_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_hierarchy_table` (
  `child_id` int(10) unsigned NOT NULL default '0',
  `parent_id` int(10) unsigned NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_hierarchy_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `status` smallint(6) NOT NULL default '10',
  `enabled` tinyint(4) NOT NULL default '1',
  `view_state` smallint(6) NOT NULL default '10',
  `access_min` smallint(6) NOT NULL default '10',
  `file_path` varchar(250) NOT NULL default '',
  `description` text NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_project_name` (`name`),
  KEY `idx_project_id` (`id`),
  KEY `idx_project_view` (`view_state`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_table`
-- 

INSERT INTO `mantis_project_table` (`id`, `name`, `status`, `enabled`, `view_state`, `access_min`, `file_path`, `description`) VALUES 
(1, 'Spring Engine', 10, 1, 10, 10, '', 'The engine'),
(2, 'Spring Site', 10, 1, 10, 10, '', 'The site');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_user_list_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_user_list_table` (
  `project_id` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL default '0',
  `access_level` smallint(6) NOT NULL default '10',
  PRIMARY KEY  (`project_id`,`user_id`),
  KEY `idx_project_user` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_user_list_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_project_version_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_project_version_table` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(10) unsigned NOT NULL default '0',
  `version` varchar(64) NOT NULL default '',
  `date_order` datetime NOT NULL default '1970-01-01 00:00:01',
  `description` text NOT NULL,
  `released` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_project_version` (`project_id`,`version`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_project_version_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_sponsorship_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_sponsorship_table` (
  `id` int(11) NOT NULL auto_increment,
  `bug_id` int(11) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `amount` int(11) NOT NULL default '0',
  `logo` varchar(128) NOT NULL default '',
  `url` varchar(128) NOT NULL default '',
  `paid` tinyint(4) NOT NULL default '0',
  `date_submitted` datetime NOT NULL default '1970-01-01 00:00:01',
  `last_updated` datetime NOT NULL default '1970-01-01 00:00:01',
  PRIMARY KEY  (`id`),
  KEY `idx_sponsorship_bug_id` (`bug_id`),
  KEY `idx_sponsorship_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_sponsorship_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_tokens_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_tokens_table` (
  `id` int(11) NOT NULL auto_increment,
  `owner` int(11) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  `expiry` datetime default NULL,
  `value` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_tokens_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_user_pref_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_user_pref_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `project_id` int(10) unsigned NOT NULL default '0',
  `default_profile` int(10) unsigned NOT NULL default '0',
  `default_project` int(10) unsigned NOT NULL default '0',
  `advanced_report` tinyint(4) NOT NULL default '0',
  `advanced_view` tinyint(4) NOT NULL default '0',
  `advanced_update` tinyint(4) NOT NULL default '0',
  `refresh_delay` int(11) NOT NULL default '0',
  `redirect_delay` tinyint(4) NOT NULL default '0',
  `bugnote_order` varchar(4) NOT NULL default 'ASC',
  `email_on_new` tinyint(4) NOT NULL default '0',
  `email_on_assigned` tinyint(4) NOT NULL default '0',
  `email_on_feedback` tinyint(4) NOT NULL default '0',
  `email_on_resolved` tinyint(4) NOT NULL default '0',
  `email_on_closed` tinyint(4) NOT NULL default '0',
  `email_on_reopened` tinyint(4) NOT NULL default '0',
  `email_on_bugnote` tinyint(4) NOT NULL default '0',
  `email_on_status` tinyint(4) NOT NULL default '0',
  `email_on_priority` tinyint(4) NOT NULL default '0',
  `email_on_priority_min_severity` smallint(6) NOT NULL default '10',
  `email_on_status_min_severity` smallint(6) NOT NULL default '10',
  `email_on_bugnote_min_severity` smallint(6) NOT NULL default '10',
  `email_on_reopened_min_severity` smallint(6) NOT NULL default '10',
  `email_on_closed_min_severity` smallint(6) NOT NULL default '10',
  `email_on_resolved_min_severity` smallint(6) NOT NULL default '10',
  `email_on_feedback_min_severity` smallint(6) NOT NULL default '10',
  `email_on_assigned_min_severity` smallint(6) NOT NULL default '10',
  `email_on_new_min_severity` smallint(6) NOT NULL default '10',
  `email_bugnote_limit` smallint(6) NOT NULL default '0',
  `language` varchar(32) NOT NULL default 'english',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_user_pref_table`
-- 

INSERT INTO `mantis_user_pref_table` (`id`, `user_id`, `project_id`, `default_profile`, `default_project`, `advanced_report`, `advanced_view`, `advanced_update`, `refresh_delay`, `redirect_delay`, `bugnote_order`, `email_on_new`, `email_on_assigned`, `email_on_feedback`, `email_on_resolved`, `email_on_closed`, `email_on_reopened`, `email_on_bugnote`, `email_on_status`, `email_on_priority`, `email_on_priority_min_severity`, `email_on_status_min_severity`, `email_on_bugnote_min_severity`, `email_on_reopened_min_severity`, `email_on_closed_min_severity`, `email_on_resolved_min_severity`, `email_on_feedback_min_severity`, `email_on_assigned_min_severity`, `email_on_new_min_severity`, `email_bugnote_limit`, `language`) VALUES 
(1, 2, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(2, 1, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(3, 4, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(4, 5, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(5, 6, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(6, 7, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(7, 8, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(8, 9, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english'),
(9, 10, 0, 0, 0, 0, 0, 0, 30, 2, 'ASC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'english');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_user_print_pref_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_user_print_pref_table` (
  `user_id` int(10) unsigned NOT NULL default '0',
  `print_pref` varchar(27) NOT NULL default '',
  PRIMARY KEY  (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_user_print_pref_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_user_profile_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_user_profile_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `platform` varchar(32) NOT NULL default '',
  `os` varchar(32) NOT NULL default '',
  `os_build` varchar(32) NOT NULL default '',
  `description` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_user_profile_table`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `mantis_user_table`
-- 

CREATE TABLE IF NOT EXISTS `mantis_user_table` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `username` varchar(32) NOT NULL default '',
  `realname` varchar(64) NOT NULL default '',
  `email` varchar(64) NOT NULL default '',
  `password` varchar(32) NOT NULL default '',
  `date_created` datetime NOT NULL default '1970-01-01 00:00:01',
  `last_visit` datetime NOT NULL default '1970-01-01 00:00:01',
  `enabled` tinyint(4) NOT NULL default '1',
  `protected` tinyint(4) NOT NULL default '0',
  `access_level` smallint(6) NOT NULL default '10',
  `login_count` int(11) NOT NULL default '0',
  `lost_password_request_count` smallint(6) NOT NULL default '0',
  `failed_login_count` smallint(6) NOT NULL default '0',
  `cookie_string` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `idx_user_cookie_string` (`cookie_string`),
  UNIQUE KEY `idx_user_username` (`username`),
  KEY `idx_enable` (`enabled`),
  KEY `idx_access` (`access_level`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `mantis_user_table`
-- 

INSERT INTO `mantis_user_table` (`id`, `username`, `realname`, `email`, `password`, `date_created`, `last_visit`, `enabled`, `protected`, `access_level`, `login_count`, `lost_password_request_count`, `failed_login_count`, `cookie_string`) VALUES 
(1, 'Administrator1', '', 'admin2@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:05:41', '2007-10-25 23:20:11', 1, 0, 90, 2, 0, 0, '250beec1feb29aa15fc1a514b5b409dfd0325a315e80a31d7704c8a0f81d3e96'),
(2, 'Administrator2', '', 'admin2@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:04:06', '2007-10-25 22:04:06', 1, 0, 90, 0, 0, 0, 'dfc41d09e9589ece3923a1a1580a8e2f7cbdb338aa405b27d7e37a07fd6028c5'),
(4, 'Moderator1', '', 'mod1@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:07:48', '2007-10-25 22:07:48', 1, 0, 70, 0, 0, 0, 'd5db4d1b93b1bba5b587e2008c99185629ca8410fc15d7d115d856fb2ef6d4ad'),
(5, 'Moderator2', '', 'mod2@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:08:24', '2007-10-25 22:08:24', 1, 0, 55, 0, 0, 0, 'd24b016c2e53b32e4f8ce00f654aeed16470990db7c55916de8d9a9d4c3f93de'),
(6, 'User1', '', 'user1@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:09:12', '2007-10-25 22:09:12', 1, 0, 25, 0, 0, 0, '844b78cf918dbfc94cae829d22c756f35cb8727ad6febbf92ba747d2a8baf672'),
(7, 'User2', '', 'user2@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:09:39', '2007-10-25 23:21:52', 1, 0, 40, 1, 0, 0, '0d5984e789ee23ea2d0ced1ead48a001d1734a1ebcf203623bd0b09f27863c5a'),
(8, 'User3', '', 'user3@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:10:12', '2007-10-25 22:10:12', 1, 0, 55, 0, 0, 0, 'b96b4c8772fd236df25b4523ed201366d5b72e219278e75d1d443c1a207f286a'),
(9, 'User4', '', 'user4@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:10:34', '2007-10-25 22:10:34', 1, 0, 10, 0, 0, 0, '74af7c75799a51e11e89ae7e3f763ae9153c6e76e8034e8267f2779ef114f0d3'),
(10, 'User5', '', 'user5@springrts.org', '098f6bcd4621d373cade4e832627b4f6', '2007-10-25 22:11:00', '2007-10-25 22:11:00', 1, 0, 25, 0, 0, 0, '8b28e58c379ffa090161fe6dd719dbb0b10dd3672471be5069759ba61f2a2961');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_auth_access`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_auth_access` (
  `group_id` mediumint(8) NOT NULL,
  `forum_id` smallint(5) unsigned NOT NULL,
  `auth_view` tinyint(1) NOT NULL,
  `auth_read` tinyint(1) NOT NULL,
  `auth_post` tinyint(1) NOT NULL,
  `auth_reply` tinyint(1) NOT NULL,
  `auth_edit` tinyint(1) NOT NULL,
  `auth_delete` tinyint(1) NOT NULL,
  `auth_sticky` tinyint(1) NOT NULL,
  `auth_announce` tinyint(1) NOT NULL,
  `auth_vote` tinyint(1) NOT NULL,
  `auth_pollcreate` tinyint(1) NOT NULL,
  `auth_attachments` tinyint(1) NOT NULL,
  `auth_mod` tinyint(1) NOT NULL,
  KEY `group_id` (`group_id`),
  KEY `forum_id` (`forum_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_auth_access`
-- 

INSERT INTO `phpbb_auth_access` (`group_id`, `forum_id`, `auth_view`, `auth_read`, `auth_post`, `auth_reply`, `auth_edit`, `auth_delete`, `auth_sticky`, `auth_announce`, `auth_vote`, `auth_pollcreate`, `auth_attachments`, `auth_mod`) VALUES 
(11, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(11, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(11, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(11, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1),
(11, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_banlist`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_banlist` (
  `ban_id` mediumint(8) unsigned NOT NULL auto_increment,
  `ban_userid` mediumint(8) NOT NULL,
  `ban_ip` char(8) NOT NULL,
  `ban_email` varchar(255) default NULL,
  PRIMARY KEY  (`ban_id`),
  KEY `ban_ip_user_id` (`ban_ip`,`ban_userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_banlist`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_categories`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_categories` (
  `cat_id` mediumint(8) unsigned NOT NULL auto_increment,
  `cat_title` varchar(100) default NULL,
  `cat_order` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`cat_id`),
  KEY `cat_order` (`cat_order`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_categories`
-- 

INSERT INTO `phpbb_categories` (`cat_id`, `cat_title`, `cat_order`) VALUES 
(1, 'Spring', 10),
(2, 'News', 20),
(3, 'Private', 30);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_config`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_config` (
  `config_name` varchar(255) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  PRIMARY KEY  (`config_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_config`
-- 

INSERT INTO `phpbb_config` (`config_name`, `config_value`) VALUES 
('config_id', '1'),
('board_disable', '0'),
('sitename', 'The Spring RTS Project'),
('site_desc', ''),
('cookie_name', 'phpbb2mysql'),
('cookie_path', '/'),
('cookie_domain', ''),
('cookie_secure', '0'),
('session_length', '3600'),
('allow_html', '0'),
('allow_html_tags', 'b,i,u,pre'),
('allow_bbcode', '1'),
('allow_smilies', '1'),
('allow_sig', '1'),
('allow_namechange', '0'),
('allow_theme_create', '0'),
('allow_avatar_local', '0'),
('allow_avatar_remote', '0'),
('allow_avatar_upload', '0'),
('enable_confirm', '1'),
('allow_autologin', '1'),
('max_autologin_time', '0'),
('override_user_style', '0'),
('posts_per_page', '15'),
('topics_per_page', '50'),
('hot_threshold', '25'),
('max_poll_options', '10'),
('max_sig_chars', '255'),
('max_inbox_privmsgs', '50'),
('max_sentbox_privmsgs', '25'),
('max_savebox_privmsgs', '50'),
('board_email_sig', 'Thanks, The Management'),
('board_email', ''),
('smtp_delivery', '1'),
('smtp_host', 'mail.desleutel.nl'),
('smtp_username', 'tim.blokdijk@desleutel.nl'),
('smtp_password', 'je+taeZ2'),
('sendmail_fix', '0'),
('require_activation', '0'),
('flood_interval', '15'),
('search_flood_interval', '15'),
('search_min_chars', '3'),
('max_login_attempts', '5'),
('login_reset_time', '30'),
('board_email_form', '0'),
('avatar_filesize', '6144'),
('avatar_max_width', '80'),
('avatar_max_height', '80'),
('avatar_path', 'images/avatars'),
('avatar_gallery_path', 'images/avatars/gallery'),
('smilies_path', 'images/smiles'),
('default_style', '1'),
('default_dateformat', 'D M d, Y g:i a'),
('board_timezone', '0'),
('prune_enable', '1'),
('privmsg_disable', '0'),
('gzip_compress', '0'),
('coppa_fax', ''),
('coppa_mail', ''),
('record_online_users', '2'),
('record_online_date', '1181170468'),
('server_name', 'localhost'),
('server_port', '80'),
('script_path', '/messageboard/'),
('version', '.0.22'),
('rand_seed', '809e6256c92432e1f759386df822f8c9'),
('board_startdate', '1180967316'),
('default_lang', 'english');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_confirm`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_confirm` (
  `confirm_id` char(32) NOT NULL,
  `session_id` char(32) NOT NULL,
  `code` char(6) NOT NULL,
  PRIMARY KEY  (`session_id`,`confirm_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_confirm`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_disallow`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_disallow` (
  `disallow_id` mediumint(8) unsigned NOT NULL auto_increment,
  `disallow_username` varchar(25) NOT NULL,
  PRIMARY KEY  (`disallow_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_disallow`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_forums`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_forums` (
  `forum_id` smallint(5) unsigned NOT NULL,
  `cat_id` mediumint(8) unsigned NOT NULL,
  `forum_name` varchar(150) default NULL,
  `forum_desc` text,
  `forum_status` tinyint(4) NOT NULL,
  `forum_order` mediumint(8) unsigned NOT NULL default '1',
  `forum_posts` mediumint(8) unsigned NOT NULL,
  `forum_topics` mediumint(8) unsigned NOT NULL,
  `forum_last_post_id` mediumint(8) unsigned NOT NULL,
  `prune_next` int(11) default NULL,
  `prune_enable` tinyint(1) NOT NULL,
  `auth_view` tinyint(2) NOT NULL,
  `auth_read` tinyint(2) NOT NULL,
  `auth_post` tinyint(2) NOT NULL,
  `auth_reply` tinyint(2) NOT NULL,
  `auth_edit` tinyint(2) NOT NULL,
  `auth_delete` tinyint(2) NOT NULL,
  `auth_sticky` tinyint(2) NOT NULL,
  `auth_announce` tinyint(2) NOT NULL,
  `auth_vote` tinyint(2) NOT NULL,
  `auth_pollcreate` tinyint(2) NOT NULL,
  `auth_attachments` tinyint(2) NOT NULL,
  PRIMARY KEY  (`forum_id`),
  KEY `forums_order` (`forum_order`),
  KEY `cat_id` (`cat_id`),
  KEY `forum_last_post_id` (`forum_last_post_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_forums`
-- 

INSERT INTO `phpbb_forums` (`forum_id`, `cat_id`, `forum_name`, `forum_desc`, `forum_status`, `forum_order`, `forum_posts`, `forum_topics`, `forum_last_post_id`, `prune_next`, `prune_enable`, `auth_view`, `auth_read`, `auth_post`, `auth_reply`, `auth_edit`, `auth_delete`, `auth_sticky`, `auth_announce`, `auth_vote`, `auth_pollcreate`, `auth_attachments`) VALUES 
(1, 1, 'General discussion', 'Various things about Spring that do not fit in any of the other forums listed below', 0, 10, 5, 4, 45, NULL, 0, 0, 0, 1, 1, 1, 1, 3, 3, 1, 1, 3),
(2, 2, 'Project News', 'The more official project news.', 0, 10, 8, 8, 10, NULL, 0, 0, 0, 1, 1, 1, 1, 3, 3, 1, 1, 0),
(3, 2, 'Community News', 'News in and arround the community.', 0, 20, 3, 3, 44, NULL, 0, 0, 0, 1, 1, 1, 1, 3, 3, 1, 1, 0),
(4, 3, 'Downloads', 'Add things that should appear in Downloads here', 0, 10, 27, 6, 41, NULL, 0, 0, 0, 1, 1, 1, 1, 3, 3, 1, 1, 0),
(5, 2, 'Highlights', 'The project highlights', 0, 20, 2, 2, 14, NULL, 0, 0, 0, 1, 1, 1, 1, 3, 3, 1, 1, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_forum_prune`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_forum_prune` (
  `prune_id` mediumint(8) unsigned NOT NULL auto_increment,
  `forum_id` smallint(5) unsigned NOT NULL,
  `prune_days` smallint(5) unsigned NOT NULL,
  `prune_freq` smallint(5) unsigned NOT NULL,
  PRIMARY KEY  (`prune_id`),
  KEY `forum_id` (`forum_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_forum_prune`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_groups`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_groups` (
  `group_id` mediumint(8) NOT NULL auto_increment,
  `group_type` tinyint(4) NOT NULL default '1',
  `group_name` varchar(40) NOT NULL,
  `group_description` varchar(255) NOT NULL,
  `group_moderator` mediumint(8) NOT NULL,
  `group_single_user` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`group_id`),
  KEY `group_single_user` (`group_single_user`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_groups`
-- 

INSERT INTO `phpbb_groups` (`group_id`, `group_type`, `group_name`, `group_description`, `group_moderator`, `group_single_user`) VALUES 
(1, 1, 'Anonymous', 'Personal User', 0, 1),
(2, 1, 'Admin', 'Personal User', 0, 1),
(3, 1, '', 'Personal User', 0, 1),
(4, 1, '', 'Personal User', 0, 1),
(5, 1, '', 'Personal User', 0, 1),
(6, 1, '', 'Personal User', 0, 1),
(7, 1, '', 'Personal User', 0, 1),
(8, 1, '', 'Personal User', 0, 1),
(9, 1, '', 'Personal User', 0, 1),
(10, 1, '', 'Personal User', 0, 1),
(11, 0, 'Moderators', 'Spring Moderators', 9, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_posts`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_posts` (
  `post_id` mediumint(8) unsigned NOT NULL auto_increment,
  `topic_id` mediumint(8) unsigned NOT NULL,
  `forum_id` smallint(5) unsigned NOT NULL,
  `poster_id` mediumint(8) NOT NULL,
  `post_time` int(11) NOT NULL,
  `poster_ip` char(8) NOT NULL,
  `post_username` varchar(25) default NULL,
  `enable_bbcode` tinyint(1) NOT NULL default '1',
  `enable_html` tinyint(1) NOT NULL,
  `enable_smilies` tinyint(1) NOT NULL default '1',
  `enable_sig` tinyint(1) NOT NULL default '1',
  `post_edit_time` int(11) default NULL,
  `post_edit_count` smallint(5) unsigned NOT NULL,
  PRIMARY KEY  (`post_id`),
  KEY `forum_id` (`forum_id`),
  KEY `topic_id` (`topic_id`),
  KEY `poster_id` (`poster_id`),
  KEY `post_time` (`post_time`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=46 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_posts`
-- 

INSERT INTO `phpbb_posts` (`post_id`, `topic_id`, `forum_id`, `poster_id`, `post_time`, `poster_ip`, `post_username`, `enable_bbcode`, `enable_html`, `enable_smilies`, `enable_sig`, `post_edit_time`, `post_edit_count`) VALUES 
(1, 1, 1, 2, 972086460, '7F000001', NULL, 1, 0, 1, 1, NULL, 0),
(2, 2, 2, 2, 1180968079, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(3, 3, 1, 2, 1180968584, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(4, 4, 2, 2, 1181133901, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(5, 5, 2, 2, 1181308153, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(6, 6, 2, 2, 1181308169, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(7, 7, 2, 2, 1181313225, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(8, 8, 2, 2, 1181313354, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(9, 9, 2, 2, 1183159641, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(10, 10, 2, 2, 1183204091, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(11, 11, 3, 2, 1187019662, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(12, 12, 5, 2, 1187019885, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(13, 13, 3, 2, 1187020178, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(14, 14, 5, 2, 1187020327, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(15, 15, 4, 7, 1187910918, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(16, 16, 4, 7, 1187911530, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(17, 16, 4, 7, 1187911564, '7f000001', '', 1, 0, 1, 0, 1187911768, 2),
(18, 16, 4, 7, 1187911587, '7f000001', '', 1, 0, 1, 0, 1187911781, 2),
(19, 16, 4, 7, 1187911607, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(20, 17, 4, 7, 1187911746, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(21, 17, 4, 7, 1187911835, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(22, 17, 4, 7, 1187911876, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(23, 17, 4, 7, 1187911900, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(24, 17, 4, 7, 1187911925, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(25, 17, 4, 7, 1187911947, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(26, 17, 4, 7, 1187911970, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(27, 17, 4, 7, 1187911993, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(28, 17, 4, 7, 1187912017, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(29, 17, 4, 7, 1187912036, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(30, 17, 4, 7, 1187912059, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(31, 18, 4, 7, 1187912137, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(32, 18, 4, 7, 1187912162, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(33, 18, 4, 7, 1187912188, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(34, 19, 4, 7, 1187912227, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(35, 19, 4, 7, 1187912249, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(36, 20, 4, 7, 1187912278, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(37, 20, 4, 7, 1187912301, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(38, 20, 4, 7, 1187912324, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(39, 20, 4, 7, 1187912343, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(40, 20, 4, 7, 1187912369, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(41, 20, 4, 7, 1187912390, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(42, 21, 1, 10, 1188301782, '7f000001', '', 1, 0, 1, 0, NULL, 0),
(43, 22, 1, 5, 1188302250, '7f000001', '', 1, 0, 0, 0, NULL, 0),
(44, 23, 3, 5, 1191189466, '7f000001', '', 1, 0, 0, 0, NULL, 0),
(45, 22, 1, 2, 1191244964, '7f000001', '', 1, 0, 1, 0, NULL, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_posts_text`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_posts_text` (
  `post_id` mediumint(8) unsigned NOT NULL,
  `bbcode_uid` char(10) NOT NULL,
  `post_subject` char(60) default NULL,
  `post_text` text,
  PRIMARY KEY  (`post_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_posts_text`
-- 

INSERT INTO `phpbb_posts_text` (`post_id`, `bbcode_uid`, `post_subject`, `post_text`) VALUES 
(1, '', NULL, 'This is an example post in your phpBB 2 installation. You may delete this post, this topic and even this forum if you like since everything seems to be working!'),
(2, 'a6f4160227', 'News Item', 'NEWS!'),
(3, '630c8e1a83', 'Front page discription', 'Test Test Test\r\n\r\nSpring is fine, Spring is good!'),
(4, 'a0b21d64f6', 'News Item 2', 'Spring xyz is like zyx but then the other way around.'),
(5, '948f798670', '123', '123'),
(6, 'f1a0ed05a2', '123456', '123456'),
(7, '1f29a6f9ca', 'Even more and more and more news', 'As in the tiltle'),
(8, 'f54a03acad', 'NEW NEWS', 'OLD NEWS'),
(9, '838982a1f1', 'Testing the 5 huor requierment', 'This post should not show in com news unless it''s 5 hours after posting.'),
(10, '3e698c1545', 'Try again', '5 hours?'),
(11, '2dd18ca17c', 'Community News', 'Community News, all people would get posting access here.\r\nIt takes 5 hours for the post to show up on the entry page, 2,5 hours on the news page. In that time moderators can edit or delete topics.'),
(12, 'b288c939c3', 'Tower Defence', '[url=http://spring.clan-sy.com/phpbb/viewtopic.php?t=11452]Check out[/url] the first version of Tower Defence!'),
(13, 'ef78c4c814', 'Spring:1944', 'Spring:1944, keep those Shermans rolling!\r\n\r\nDownload version x.x here.\r\nNote that bla. bla.'),
(14, '347b8d0680', 'Spring:1944', 'Spring:1944, keep [url=http://spring.clan-sy.com/phpbb/viewtopic.php?t=8584]those[/url] Shermans rolling!'),
(15, 'c3f065bcb6', 'How this works', 'Each thread is a download category, and each post in a thread is one entry under that category. They are sorted by date, so latest post is at the top.\r\n\r\nIn the post, write a description followed by --- and then links on a separate line each. Supported protocols are http :// and bt ://, see existing posts for examples..\r\n\r\n[Edit (22/01/2006, Betalord): I''ve modified the script to allow manual positioning of the items, put a $x in front of the topic title to set its position to some fixed value, where x is the position - 0 for the 1st spot, 1 for the 2nd, and so on.]'),
(16, '5fd949cf58', '1Other things', 'This is a collection of files that are related to the Spring project in some way, such as old versions of the Spring engine. Note that these files are NOT releases from the TA Spring project, they are just provided for those who are curious as to where this project comes from.'),
(17, '72b6c4114d', 'The old old old Spring', 'This is a very old version of Spring, where players control various different &quot;Bagge&quot;s and fight their opponent.\r\n---\r\nhttp://taspring.clan-sy.com/dl/bagge-old.rar'),
(18, '273fe1c628', 'The old old Spring', 'This is the first publically released version of the original Spring engine, released sometime in 2001. \r\n\r\nThis small demo is just meant to show how TA could look in 3d, without any real interaction capabilites. \r\n\r\nNote that the textures are generated the first time you run it and all units will appear as red blobs. Just restart once to get the textures... and read the included readme! \r\n--- \r\nhttp://taspring.clan-sy.com/dl/spring.zip'),
(19, '8ec67d3331', 'The old Spring', 'This is more recent version of Spring, but it does not use TA units though.\r\n---\r\nhttp://taspring.clan-sy.com/dl/bagge.rar'),
(20, '85a6428199', '2Videos', 'This is a collection of video clips showing various aspects of the Spring engine. They are encoded using either [url=http://www.xvid.org]XviD[/url] or [url=http://www.divx.com]DivX[/url]. To make sure you can play them, you can install something like [url=http://ffdshow.sourceforge.net/tikiwiki]ffdshow[/url] or use a player with built-in codecs such as [url=http://www.videolan.org/vlc/]VLC[/url].'),
(21, 'db51a26888', 'Video 1', 'This clip shows some aerial combat in a close up follow mode. \r\n--- \r\nhttp://taspring.clan-sy.com/dl/video1.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=379'),
(22, 'e7f54aaab4', 'Video 3', 'This is a small videoclip showing some stuff.  It''s compressed with divx5 so you should probably have that. \r\n--- \r\nhttp://taspring.clan-sy.com/dl/video3.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=377'),
(23, 'dfd662d897', 'Video 2', 'Here is a clip displaying [url=http://www.planetannihilation.com/swta/]StarWarsTA[/url] on a new map. \r\n--- \r\nhttp://taspring.clan-sy.com/dl/video2.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=378'),
(24, 'e001301b49', 'Video 5', 'This video clip displays a naval assault with hovers and ships, and even some bombing going on. \r\n--- \r\nhttp://taspring.clan-sy.com/dl/video5.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=375'),
(25, '937e4f05b6', 'Video 0', 'Shows the new cool explosion physics.\r\n--- \r\nhttp://taspring.clan-sy.com/dl/video0.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=380'),
(26, '228f90f8cb', 'Video 6', 'This is a short clip featuring the mod [url=http://www.planetannihilation.com/aa/]Absolute Annihilation[/url].\r\n---\r\nhttp://taspring.clan-sy.com/dl/video6.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=374'),
(27, '172141e7be', 'Video 7', 'This is a video in two parts from a multiplayer game. This one shows the construction of our bases.\r\n---\r\nhttp://taspring.clan-sy.com/dl/video7.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=373'),
(28, 'fd6cbf982c', 'Video 8', 'The second part of the multiplayer game where we actually start the fighting! It is somewhat large, but it is also about four minutes long.\r\n---\r\nhttp://taspring.clan-sy.com/dl/video8.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=372'),
(29, 'e870c86e7c', 'Video 9', 'A video clip featuring the latest feature, shadows.\r\n---\r\nhttp://taspring.clan-sy.com/dl/video9.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=371'),
(30, 'c406fadc18', 'Video 10', 'SJ shows off his mad Quake skillz by taking on several dozen arm units using only two of his own (krogoth what krogoth :)).\r\n---\r\nhttp://taspring.clan-sy.com/dl/video10v2.avi\r\nhttp://www.fileuniverse.com/?page=showitem&amp;ID=370'),
(31, 'f3d37c5c1e', '3Development', 'This category contains items relevant to the development of Spring, such as the source code, and links to the latest development and nightly builds.'),
(32, '50ed8e7811', 'Source code', 'This is the full source to TA Spring 0.74b3, released under the GPL. You can get the work-in-progress source from our SVN repository at [url]https://spring.clan-sy.com/svn/spring/trunk/[/url]\r\nFor building the code, see this [url=http://spring.clan-sy.com/phpbb/viewtopic.php?t=3409]forum thread[/url].\r\n--- \r\nhttp://prdownload.berlios.de/taspring-linux/spring_0.74b3_src.tar.bz2\r\nhttp://prdownload.berlios.de/taspring-linux/spring_0.74b3_src.zip'),
(33, '33ba598cf8', 'Automated test builds', 'Automatic builds of the latest development version. These probably has bugs and should not be used for online play, but it allows you to test out the latest new features in spring. \r\n--- \r\nhttp://www.osrts.info/~buildbot/spring/executable'),
(34, '6c2ac85c48', '4External utilities', 'This category contains useful spring tools not made by the Spring team.'),
(35, 'd223f38ed0', 'SpringSP 0.8', 'You can use SpringSP to easily start single player games against AIs.\r\n---\r\nhttp://spring.unknown-files.net/?page=browse&amp;dlid=2012'),
(36, 'f6a9499841', '5Spring releases', 'This category contains the latest releases from the Spring project. \r\nThe listed installers are for Windows, for linux see the [url=http://spring.clan-sy.com/wiki/SetupGuide]linux setup guide[/url].\r\n\r\nMake sure that you download the latest drivers for your graphic card in order to make Spring work correctly.'),
(37, '04bec2439e', '$3 Lobby server (Windows)', 'Download this if you want to use spring on a LAN (on Windows), for normal internet play you don''t need this. See the readme [url=http://spring.clan-sy.com/dl/tasserver_readme.txt]here[/url].\r\n--- \r\nhttp://spring.clan-sy.com/dl/TASServer_033.exe'),
(38, '74c78272cc', '$1 0.74b3 Updating installer', 'This installer updates any 0.74b1 or 0.74b2 installation to 0.74b3.\r\n---\r\nhttp://spring.clan-sy.com/dl/spring_0.74b3_update.exe'),
(39, 'ba12138538', '$2 GPL content installer', 'This installer comes without any TA content. It contains the mod nanoblobs which is licensed under GPL/Creative Commons.\r\n---\r\nhttp://spring.clan-sy.com/dl/spring_0.74b3_gpl.exe'),
(40, '08b0ff861e', '$0 Regular installer', 'This installer contains everything you need to play TA Spring, including the core files, two different maps, and the TA mod XTA. This mod, like all TA mods, contains content from the game Total Annihilation. Therefore you will have to own a copy of TA to legally use this content.\r\n---\r\nhttp://spring.clan-sy.com/dl/spring_0.74b3.exe'),
(41, '3b626cd0f8', '$4 Lobby server (Linux)', 'Download this if you want to use spring on a LAN (under Linux), for normal internet play you don''t need this. See the readme [url=http://spring.clan-sy.com/dl/tasserver_readme.txt]here[/url].\r\n---\r\nhttp://spring.clan-sy.com/dl/TASServer.jar'),
(42, '1fb1ddc530', 'Accounts', 'This messageboard has the following accounts:\r\n\r\nUser1\r\nUser2 (inactive)\r\nUser3 (inactive)\r\nUser4\r\nUser5\r\n\r\nModerator1\r\nModerator2\r\n\r\nAdministrator1\r\nAdministrator2 (inactive)\r\n\r\nAll have the password &quot;test&quot;.\r\nAnd note the capital letter in the user name.\r\n\r\nTest away!'),
(43, '74f181de39', 'Characters support test', '// Also see how \\\\ Slashes are used.\r\n&lt;HTML&gt; and other &lt;SCRIPT&gt;tags&lt;\\SCRIPT&gt; like &lt;IMG SRC=&quot;picture.png&quot;&gt;, &lt;OBJECT&gt; and &lt;EMBED&gt;.\r\nAll sorts of `&quot;''Â¨Â´'' quotes.\r\nChina:\r\næ‘˜ã€€è¦ï¼šåœ¨åˆ†æžä¿¡ç”¨è¯„ä¼°é‡è¦æ€§å’Œä¿¡ç”¨è¯„ä¼°å›½å†…å¤–çŽ°çŠ¶çš„åŸºç¡€ä¸Š,æå‡ºäº†ç”¨äºŽä¼ä¸šä¿¡ç”¨è¯„ä¼°çš„æŒ‡æ ‡ä½“ç³»,ç»™å‡ºäº†æŒ‡æ ‡ä½“ç³»ä¸­ç¦»æ•£æ•°æ®çš„é‡åŒ–æ–¹æ³•å’ŒæŒ‡æ ‡æ•°æ®çš„å½’ä¸€å¤„ç†æ–¹æ³•.æ ¹æ®è¿™ä¸€æŒ‡æ ‡ä½“ç³»å»ºç«‹äº†åŸºäºŽBPç¥žç»ç½‘ç»œçš„ä¼ä¸šä¿¡ç”¨3å±‚ç¥žç»ç½‘ç»œè¯„ä¼°æ¨¡åž‹.è¯¥æ¨¡åž‹é€šè¿‡ç»™å®šçš„æ•™å¸ˆæ•°æ®è®­ç»ƒåŽ,å…·æœ‰äº†å¯¹ä¼ä¸šä¿¡ç”¨çš„é¢„æµ‹åŠŸèƒ½.å®žéªŒç»“æžœè¯æ˜Ž,è¯¥æ¨¡åž‹ç”¨äºŽä¼ä¸šä¿¡ç”¨è¯„ä¼°,å‡å°‘äº†ä¼ä¸šä¿¡ç”¨è¯„ä¼°ä¼ ç»Ÿçš„å®šæ€§æ–¹æ³•ä¸­æƒé‡ç¡®å®šçš„äººä¸ºå› ç´ ,è¯„ä¼°æ­£ç¡®çŽ‡è¾¾åˆ°\r\nJapan:\r\nãƒ—ãƒ­ãƒ¢ãƒ“ãƒ‡ã‚ªã‚’ä¸­å¿ƒã«äººæ°—å‹•ç”»ã‚’æŽ¢ã›ã‚‹ã‚µã‚¤ãƒˆ\r\nTaiwan:\r\nä¸­å›½ç”µè§†æ¸¸æˆç¬¬ä¸€é—¨æˆ·-ç”µçŽ©å·´å£«-ç”µè§†æ¸¸æˆ|ç”µå­æ¸¸æˆ\r\nKorea:\r\në°‘ì— ìƒ¤ì˜¤ë‹˜ê»˜ì„œ ì ìš©ì´ ì•ˆëœë‹¤ê³  í•˜ì‹œê¸°ì— ë‹¤ë¥¸ ë¶„ë“¤ê»˜ë„ í˜¹ ì œ ê²½í—˜ì´ ë„ì›€ë ê¹Œ ì‹¶ì–´ ê´œížˆ ê¸¸ê²Œ ë„ì ì—¬ ë´…ë‹ˆë‹¤.\r\nArabic:\r\nÙˆÙŠÙƒÙŠØ¨ÙŠØ¯ÙŠØ§ Ù…Ø´Ø±ÙˆØ¹ Ù…ØªØ¹Ø¯Ø¯ Ø§Ù„Ù„ØºØ§Øª ÙÙŠ Ø£ÙƒØ«Ø± Ù…Ù† 250 Ù„ØºØ© Ù„ØµÙ†Ø¹ Ù…ÙˆØ³ÙˆØ¹Ø© Ø¯Ù‚ÙŠÙ‚Ø© ÙˆÙ…ØªÙƒØ§Ù…Ù„Ø© ÙˆÙ…ØªÙ†ÙˆØ¹Ø© ÙˆÙ…ÙØªÙˆØ­Ø© ÙˆÙ…Ø­Ø§ÙŠØ¯Ø© ÙˆÙ…Ø¬Ø§Ù†ÙŠØ© Ù„Ù„Ø¬Ù…ÙŠØ¹ØŒ ÙŠØ³ØªØ·ÙŠØ¹ Ø§Ù„Ø¬Ù…ÙŠØ¹ Ø§Ù„Ù…Ø³Ø§Ù‡Ù…Ø© ÙÙŠ ØªØ­Ø±ÙŠØ±Ù‡Ø§. Ø¨Ø¯Ø£Øª Ø§Ù„Ù†Ø³Ø®Ø© Ø§Ù„Ø¹Ø±Ø¨ÙŠØ© ÙÙŠ Ø³Ø¨ØªÙ…Ø¨Ø±\r\nHebrew:\r\n×¢×œ×™×œ×•×ª ×‘×¢×œ ×•×¢× ×ª ×”×•× ××¤×•×¡ ×ž×™×ª×•×œ×•×’×™ ×§×“×•×, ×”×ž×¡×¤×¨ ××ª ×¡×™×¤×•×¨× ×©×œ ××œ×™ ×›× ×¢×Ÿ ×•××•×’×¨×™×ª, ×•× ×—×©×‘ ×œ×ž×™×ª×•×¡\r\nSwidish:\r\nÃ¥Ã¶Ã¤\r\nDutch:\r\nÃ©Ã¨Ã«'),
(44, '69c428efcf', 'Test', 'test'),
(45, '5125e7828e', '', 'Arabic\r\n\r\nØªØ±Ø§Ùƒ ÙŠÙ‚ÙˆÙ… Ø¨Ø­ÙØ¸ ÙƒÙ„ Ø§Ù„ÙƒÙ„Ù…Ø§Øª Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… ØµÙŠØºØ© UTF-8ØŒ Ø¨Ù…Ø§ ÙÙŠ Ø°Ù„Ùƒ Ø§Ù„ÙƒÙ„Ù…Ø§Øª Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…Ø© ÙÙŠ ØµÙØ­Ø§Øª Ø§Ù„ØªÙŠÙƒØª ÙˆØ§Ù„ÙˆÙŠÙƒÙŠ.\r\nBulgarian\r\n\r\nÐ‘ÑŠÐ»Ð³Ð°Ñ€ÑÐºÐ¸ÑÑ‚ ÐµÐ·Ð¸Ðº Ñ€Ð°Ð±Ð¾Ñ‚Ð¸ Ð»Ð¸?\r\nÄŒesky\r\n\r\nÄŒeÅ¡tina v kÃ³dovÃ¡nÃ­ UTF-8, Å¾Ã¡dnÃ½ problÃ©m.\r\nChinese\r\n\r\nTraditional: ç¹é«”ä¸­æ–‡, æ¼¢å­—æ¸¬è©¦; Simplified: ç®€ä½“ä¸­æ–‡ï¼Œæ±‰å­—æµ‹è¯•\r\nCroatian\r\n\r\nAko podrÅ¾ava srpski i slovenski mora podrÅ¾avati i Hrvatski - ÄÄ‡Å¾Å¡Ä‘ ÄŒÄ†Å½Å Ä\r\nEnglish\r\n\r\nYes indeed, Trac supports English. Fully.\r\nFranÃ§ais\r\n\r\nIl est possible d''Ã©crire en FranÃ§ais : Ã , Ã§, Ã», ...\r\nGerman\r\n\r\nTrac-Wiki muÃŸ auch deutsche Umlaute richtig anzeigen: Ã¶, Ã¤, Ã¼, Ã„, Ã–, Ãœ; und das scharfe ÃŸ\r\nGreek\r\n\r\nÎ¤Î± Î•Î»Î»Î·Î½Î¹ÎºÎ¬ Ï…Ï€Î¿ÏƒÏ„Î·ÏÎ¯Î¶Î¿Î½Ï„Î±Î¹ ÎµÏ€Î±ÏÎºÏŽÏ‚ ÎµÏ€Î¯ÏƒÎ·Ï‚.\r\nHebrew\r\n\r\n×× ×™ ×™×›×•×œ ×œ××›×•×œ ×–×›×•×›×™×ª ×•×–×” ×œ× ×ž×–×™×§ ×œ×™\r\nHindi\r\n\r\nà¤…à¤¬ à¤¹à¤¿à¤¨à¥à¤¦à¥€ à¤®à¥‡à¤‚à¥¤\r\nHungarian\r\n\r\nÃrvÃ­ztÅ±rÅ‘ tÃ¼kÃ¶rfÃºrÃ³gÃ©p\r\nIcelandic\r\n\r\nÃ†var sagÃ°i viÃ° Ã¶mmu sÃ­na: SjÃ¡Ã°u hvaÃ° Ã©g er stÃ³r!\r\nJapanese\r\n\r\næ¼¢å­— ã²ã‚‰ãŒãª ã‚«ã‚¿ã‚«ãƒŠ ï¾Šï¾ï½¶ï½¸ï½¶ï¾… æ—¥æœ¬èªžè©¦é¨“\r\nKorean\r\n\r\nì´ë²ˆì—ëŠ” í•œê¸€ë¡œ ì¨ë³´ê² ìŠµë‹ˆë‹¤. ìž˜ ë³´ì´ë‚˜ìš”? í•œê¸€\r\nLatvian\r\n\r\nLatvieÅ¡u valoda arÄ« strÄdÄ!\r\nLithuanian\r\n\r\nSudalyvaukime ir mes. Ar veikia lietuviÅ¡kos raidÄ—s? Ä…ÄÄ™Ä—Ä¯Å¡Å³Å«Å¾ Ä„ÄŒÄ˜Ä–Ä®Å Å²ÅªÅ½ Å½inoma, kad veikia :) Kas tie mes?\r\nPersian (Farsi)\r\n\r\nØ§ÛŒÙ† ÛŒÚ© Ù…ØªÙ† ÙØ§Ø±Ø³ÛŒ Ø§Ø³Øª ÙˆÙ„ÛŒ Ø§Ù…Ú©Ø§Ù† Ù†ÙˆØ´ØªÙ† Ù…Ø³ØªÙ‚ÛŒÙ… ÙØ§Ø±Ø³ÛŒ Ù†ÛŒØ³Øª Ú†ÙˆÙ† Ø­Ø§Ù„Øª Ù…ØªÙ† Ø§Ø² Ø±Ø§Ø³Øª Ø¨Ù‡ Ú†Ù¾ Ùˆ Ø¬ÙˆØ¯ Ù†Ø¯Ø§Ø±Ø¯ Ø¨Ø±Ø§ÛŒ ÙØ§Ø±Ø³ÛŒ Ù†ÙˆØ´ØªÙ† Ø¨Ø§ÛŒØ¯ Ø§Ø² HTML Ø§Ø³ØªÙØ§Ø¯Ù‡ Ú©Ù†ÛŒØ¯.\r\n\r\nØ§ÛŒÙ† Ù†Ù…ÙˆÙ†Ù‡ ÛŒÚ© Ù…ØªÙ† Ø§Ø² Ø±Ø§Ø³Øª Ø¨Ù‡ Ú†Ù¾ ÙØ§Ø±Ø³ÛŒ Ø§Ø³Øª Ú©Ù‡ Ø¯Ø± HTML Ù†ÙˆØ´ØªÙ‡ Ø´Ø¯Ù‡ ØªØ§ Ø§Ø¹Ø¯Ø§Ø¯ 12345 Ùˆ Ø­Ø±ÙˆÙ Ù„Ø§ØªÛŒÙ† ABCDEF Ø¯Ø± Ù…Ø­Ù„ Ø®ÙˆØ¯Ø´Ø§Ù† Ù†Ù…Ø§ÛŒØ´ Ø¯Ø§Ø¯Ù‡ Ø´ÙˆÙ†Ø¯.\r\nPolish\r\n\r\nPchnÄ…Ä‡ w tÄ™ Å‚Ã³dÅº jeÅ¼a lub osiem skrzyÅ„ fig; Nocna gÅ¼egÅ¼Ã³Å‚ka zawsze dziennÄ… przekuka.\r\nPortuguese\r\n\r\nÃ‰ possÃ­vel guardar caracteres especias da lÃ­ngua portuguesa, incluindo o sÃ­mbolo da moeda europÃ©ia ''â‚¬'', trema ''Ã¼'', crase ''Ã '', agudos ''Ã¡Ã©Ã­Ã³Ãº'', circunflexos ''Ã¢ÃªÃ´'', til ''Ã£Ãµ'', cedilha ''Ã§'', ordinais ''ÂªÂº'', grau ''Â°Â¹Â²Â³''.\r\nRussian\r\n\r\nÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ° Ñ€ÑƒÑÑÐºÐ¾Ð³Ð¾ ÑÐ·Ñ‹ÐºÐ°: ÐºÐ°Ð¶ÐµÑ‚ÑÑ Ñ€Ð°Ð±Ð¾Ñ‚Ð°ÐµÑ‚... Ð˜ Ð±ÑƒÐºÐ²Ð° &quot;Ñ‘&quot; ÐµÑÑ‚ÑŒ...\r\nSerbian\r\n\r\nPodrÅ¾an, uprkos Äinjenici da se za njegovo pisanje koriste Ñ‡Ð°Ðº Ð´Ð²Ð° Ð°Ð»Ñ„Ð°Ð±ÐµÑ‚Ð°.\r\nSlovenian\r\n\r\nTa suhi Å¡kafec puÅ¡Äa vodo Å¾e od nekdaj!\r\nSpanish\r\n\r\nEsto es un pequeÃ±o texto en EspaÃ±ol, ahora una con acentÃ³\r\nSwedish\r\n\r\nRÃ¤ven raskar Ã¶ver isen med luva pÃ¥.\r\nThai\r\n\r\nTrac à¹à¸ªà¸”à¸‡à¸ à¸²à¸©à¸²à¹„à¸—à¸¢à¹„à¸”à¹‰à¸­à¸¢à¹ˆà¸²à¸‡à¸–à¸¹à¸à¸•à¹‰à¸­à¸‡!\r\nUkrainian\r\n\r\nÐŸÐµÑ€ÐµÐ²Ñ–Ñ€ÐºÐ° ÑƒÐºÑ€Ð°Ñ—Ð½ÑÑŒÐºÐ¾Ñ— Ð¼Ð¾Ð²Ð¸...\r\nUrdu\r\n\r\nÙ¹Ø±ÛŒÚ© Ø§Ø±Ø¯Ùˆ Ø¨Ú¾ÛŒ Ø³Ù¾ÙˆØ±Ù¹ Ú©Ø±ØªØ§ ÛÛ’Û”\r\nVietnamese\r\n\r\nViáº¿t tiáº¿ng Viá»‡t cÅ©ng Ä‘Æ°á»£c. NhÆ°ng search tá»« tiáº¿ng Viá»‡t thÃ¬ khÃ´ng bÃ´i vÃ ng Ä‘Æ°á»£c.');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_privmsgs`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_privmsgs` (
  `privmsgs_id` mediumint(8) unsigned NOT NULL auto_increment,
  `privmsgs_type` tinyint(4) NOT NULL,
  `privmsgs_subject` varchar(255) NOT NULL,
  `privmsgs_from_userid` mediumint(8) NOT NULL,
  `privmsgs_to_userid` mediumint(8) NOT NULL,
  `privmsgs_date` int(11) NOT NULL,
  `privmsgs_ip` char(8) NOT NULL,
  `privmsgs_enable_bbcode` tinyint(1) NOT NULL default '1',
  `privmsgs_enable_html` tinyint(1) NOT NULL,
  `privmsgs_enable_smilies` tinyint(1) NOT NULL default '1',
  `privmsgs_attach_sig` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`privmsgs_id`),
  KEY `privmsgs_from_userid` (`privmsgs_from_userid`),
  KEY `privmsgs_to_userid` (`privmsgs_to_userid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_privmsgs`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_privmsgs_text`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_privmsgs_text` (
  `privmsgs_text_id` mediumint(8) unsigned NOT NULL,
  `privmsgs_bbcode_uid` char(10) NOT NULL,
  `privmsgs_text` text,
  PRIMARY KEY  (`privmsgs_text_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_privmsgs_text`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_ranks`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_ranks` (
  `rank_id` smallint(5) unsigned NOT NULL auto_increment,
  `rank_title` varchar(50) NOT NULL,
  `rank_min` mediumint(8) NOT NULL,
  `rank_special` tinyint(1) default NULL,
  `rank_image` varchar(255) default NULL,
  PRIMARY KEY  (`rank_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_ranks`
-- 

INSERT INTO `phpbb_ranks` (`rank_id`, `rank_title`, `rank_min`, `rank_special`, `rank_image`) VALUES 
(1, 'Site Admin', -1, 1, NULL);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_search_results`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_search_results` (
  `search_id` int(11) unsigned NOT NULL,
  `session_id` char(32) NOT NULL,
  `search_time` int(11) NOT NULL,
  `search_array` mediumtext NOT NULL,
  PRIMARY KEY  (`search_id`),
  KEY `session_id` (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_search_results`
-- 

INSERT INTO `phpbb_search_results` (`search_id`, `session_id`, `search_time`, `search_array`) VALUES 
(1629221419, '97461cee01282074c1d4d5afdf2ae5a8', 1181597213, 'a:7:{s:14:"search_results";s:22:"1, 2, 3, 4, 5, 6, 7, 8";s:17:"total_match_count";i:8;s:12:"split_search";N;s:7:"sort_by";i:0;s:8:"sort_dir";s:4:"DESC";s:12:"show_results";s:6:"topics";s:12:"return_chars";i:200;}');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_search_wordlist`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_search_wordlist` (
  `word_text` varchar(50) NOT NULL,
  `word_id` mediumint(8) unsigned NOT NULL auto_increment,
  `word_common` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY  (`word_text`),
  KEY `word_id` (`word_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=755 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_search_wordlist`
-- 

INSERT INTO `phpbb_search_wordlist` (`word_text`, `word_id`, `word_common`) VALUES 
('example', 1, 0),
('post', 2, 0),
('phpbb', 3, 0),
('installation', 4, 0),
('delete', 5, 0),
('topic', 6, 0),
('forum', 7, 0),
('since', 8, 0),
('everything', 9, 0),
('seems', 10, 0),
('working', 11, 0),
('welcome', 12, 0),
('item', 13, 0),
('discription', 14, 0),
('fine', 15, 0),
('front', 16, 0),
('spring', 17, 0),
('test', 18, 0),
('xyz', 19, 0),
('zyx', 20, 0),
('123', 21, 0),
('123456', 22, 0),
('more', 23, 0),
('tiltle', 24, 0),
('com', 25, 0),
('hours', 26, 0),
('huor', 27, 0),
('posting', 28, 0),
('requierment', 29, 0),
('show', 30, 0),
('testing', 31, 0),
('unless', 32, 0),
('again', 33, 0),
('try', 34, 0),
('takes', 64, 0),
('community', 36, 0),
('people', 63, 0),
('moderators', 62, 0),
('entry', 61, 0),
('edit', 60, 0),
('access', 59, 0),
('5', 58, 0),
('check', 43, 0),
('defense', 44, 0),
('first', 45, 0),
('tower', 46, 0),
('1944', 47, 0),
('keep', 53, 0),
('download', 52, 0),
('bla', 51, 0),
('note', 54, 0),
('rolling', 55, 0),
('shermans', 56, 0),
('x', 57, 0),
('topics', 65, 0),
('01', 66, 0),
('1st', 67, 0),
('2006', 68, 0),
('2nd', 69, 0),
('allow', 70, 0),
('betalord', 71, 0),
('category', 72, 0),
('date', 73, 0),
('examples', 74, 0),
('existing', 75, 0),
('fixed', 76, 0),
('followed', 77, 0),
('http', 78, 0),
('items', 79, 0),
('ive', 80, 0),
('latest', 81, 0),
('line', 82, 0),
('links', 83, 0),
('manual', 84, 0),
('modified', 85, 0),
('one', 86, 0),
('position', 87, 0),
('positioning', 88, 0),
('posts', 89, 0),
('protocols', 90, 0),
('script', 91, 0),
('seperate', 92, 0),
('set', 93, 0),
('sorted', 94, 0),
('spot', 95, 0),
('supported', 96, 0),
('thread', 97, 0),
('title', 98, 0),
('top', 99, 0),
('value', 100, 0),
('works', 101, 0),
('write', 102, 0),
('1other', 103, 0),
('collection', 104, 0),
('comes', 105, 0),
('curious', 106, 0),
('engine', 107, 0),
('files', 108, 0),
('project', 109, 0),
('provided', 110, 0),
('related', 111, 0),
('releases', 112, 0),
('such', 113, 0),
('things', 114, 0),
('versions', 115, 0),
('bagge', 116, 0),
('various', 179, 0),
('clip', 226, 0),
('control', 198, 0),
('different', 199, 0),
('fight', 200, 0),
('aerial', 225, 0),
('379', 224, 0),
('opponent', 201, 0),
('close', 227, 0),
('textures', 223, 0),
('run', 222, 0),
('restart', 221, 0),
('released', 220, 0),
('red', 219, 0),
('real', 218, 0),
('readme', 217, 0),
('read', 216, 0),
('publically', 215, 0),
('old', 160, 0),
('original', 214, 0),
('meant', 213, 0),
('interaction', 212, 0),
('included', 211, 0),
('generated', 210, 0),
('demo', 209, 0),
('capabilites', 208, 0),
('blobs', 207, 0),
('appear', 206, 0),
('units', 148, 0),
('3d', 205, 0),
('2001', 204, 0),
('2videos', 180, 0),
('aspects', 181, 0),
('builtin', 182, 0),
('clips', 183, 0),
('codecs', 184, 0),
('divx', 185, 0),
('encoded', 186, 0),
('ffdshow', 187, 0),
('install', 188, 0),
('make', 189, 0),
('play', 190, 0),
('player', 191, 0),
('showing', 192, 0),
('sure', 193, 0),
('using', 194, 0),
('video', 195, 0),
('vlc', 196, 0),
('xvid', 197, 0),
('players', 202, 0),
('quot', 203, 0),
('combat', 228, 0),
('follow', 229, 0),
('mode', 230, 0),
('shows', 231, 0),
('377', 232, 0),
('compressed', 233, 0),
('divx5', 234, 0),
('probably', 235, 0),
('stuff', 236, 0),
('videoclip', 237, 0),
('378', 238, 0),
('displaying', 239, 0),
('map', 240, 0),
('starwarsta', 241, 0),
('375', 242, 0),
('assault', 243, 0),
('bombing', 244, 0),
('displays', 245, 0),
('hovers', 246, 0),
('naval', 247, 0),
('ships', 248, 0),
('380', 249, 0),
('cool', 250, 0),
('explosion', 251, 0),
('physics', 252, 0),
('374', 253, 0),
('absolute', 254, 0),
('annihilation', 255, 0),
('featuring', 256, 0),
('mod', 257, 0),
('short', 258, 0),
('373', 259, 0),
('bases', 260, 0),
('construction', 261, 0),
('game', 262, 0),
('multiplayer', 263, 0),
('parts', 264, 0),
('two', 265, 0),
('372', 266, 0),
('actually', 267, 0),
('fighting', 268, 0),
('four', 269, 0),
('long', 270, 0),
('minutes', 271, 0),
('part', 272, 0),
('second', 273, 0),
('somewhat', 274, 0),
('start', 275, 0),
('371', 276, 0),
('feature', 277, 0),
('shadows', 278, 0),
('370', 279, 0),
('arm', 280, 0),
('dozen', 281, 0),
('krogoth', 282, 0),
('mad', 283, 0),
('own', 284, 0),
('quake', 285, 0),
('several', 286, 0),
('skillz', 287, 0),
('taking', 288, 0),
('3development', 289, 0),
('builds', 290, 0),
('code', 291, 0),
('contains', 292, 0),
('development', 293, 0),
('nightly', 294, 0),
('relevant', 295, 0),
('source', 296, 0),
('74b3', 297, 0),
('building', 298, 0),
('full', 299, 0),
('gpl', 300, 0),
('repository', 301, 0),
('svn', 302, 0),
('ta', 303, 0),
('workinprogress', 304, 0),
('allows', 305, 0),
('automated', 306, 0),
('automatic', 307, 0),
('bugs', 308, 0),
('buildbot', 309, 0),
('executable', 310, 0),
('features', 311, 0),
('online', 312, 0),
('used', 313, 0),
('4external', 314, 0),
('made', 315, 0),
('team', 316, 0),
('tools', 317, 0),
('useful', 318, 0),
('utilities', 319, 0),
('8', 320, 0),
('2012', 321, 0),
('against', 322, 0),
('ais', 323, 0),
('dlid', 324, 0),
('easily', 325, 0),
('games', 326, 0),
('single', 327, 0),
('springsp', 328, 0),
('5spring', 329, 0),
('card', 330, 0),
('correctly', 331, 0),
('drivers', 332, 0),
('graphic', 333, 0),
('guide', 334, 0),
('installers', 335, 0),
('linux', 336, 0),
('listed', 337, 0),
('order', 338, 0),
('setup', 339, 0),
('windows', 340, 0),
('work', 341, 0),
('internet', 342, 0),
('lan', 343, 0),
('lobby', 344, 0),
('normal', 345, 0),
('server', 346, 0),
('0', 347, 0),
('74b1', 348, 0),
('74b2', 349, 0),
('installer', 350, 0),
('updates', 351, 0),
('updating', 352, 0),
('commons', 353, 0),
('content', 354, 0),
('creative', 355, 0),
('licensed', 356, 0),
('nanoblobs', 357, 0),
('copy', 358, 0),
('core', 359, 0),
('including', 360, 0),
('legally', 361, 0),
('maps', 362, 0),
('mods', 363, 0),
('regular', 364, 0),
('therefore', 365, 0),
('total', 366, 0),
('xta', 367, 0),
('accounts', 368, 0),
('password', 394, 0),
('name', 393, 0),
('moderator2', 392, 0),
('moderator1', 391, 0),
('messageboard', 390, 0),
('letter', 389, 0),
('inactive', 388, 0),
('following', 387, 0),
('capital', 386, 0),
('away', 385, 0),
('administrator2', 384, 0),
('administrator1', 383, 0),
('user', 395, 0),
('user1', 396, 0),
('user2', 397, 0),
('user3', 398, 0),
('user4', 399, 0),
('user5', 400, 0),
('250', 401, 0),
('arabic', 402, 0),
('characters', 403, 0),
('china', 404, 0),
('dutch', 405, 0),
('embed', 406, 0),
('hebrew', 407, 0),
('html', 408, 0),
('img', 409, 0),
('japan', 410, 0),
('korea', 411, 0),
('object', 412, 0),
('picture', 413, 0),
('png', 414, 0),
('quotes', 415, 0),
('slashes', 416, 0),
('sorts', 417, 0),
('src', 418, 0),
('support', 419, 0),
('swidish', 420, 0),
('tags', 421, 0),
('taiwan', 422, 0),
('Â¨Â´', 423, 0),
('Ã¥Ã¶Ã¤', 424, 0),
('Ã©Ã¨Ã«', 425, 0),
('××œ×™', 426, 0),
('××¤×•×¡', 427, 0),
('××ª', 428, 0),
('×‘×¢×œ', 429, 0),
('×”×•×', 430, 0),
('×”×ž×¡×¤×¨', 431, 0),
('×•××•×’×¨×™×ª', 432, 0),
('×•× ×—×©×‘', 433, 0),
('×•×¢× ×ª', 434, 0),
('×›× ×¢×Ÿ', 435, 0),
('×œ×ž×™×ª×•×¡', 436, 0),
('×ž×™×ª×•×œ×•×’×™', 437, 0),
('×¡×™×¤×•×¨×', 438, 0),
('×¢×œ×™×œ×•×ª', 439, 0),
('×§×“×•×', 440, 0),
('×©×œ', 441, 0),
('Ø£ÙƒØ«Ø±', 442, 0),
('Ø§Ù„Ø¬Ù…ÙŠØ¹', 443, 0),
('Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©', 444, 0),
('Ø§Ù„Ù„ØºØ§Øª', 445, 0),
('Ø§Ù„Ù…Ø³Ø§Ù‡Ù…Ø©', 446, 0),
('Ø§Ù„Ù†Ø³Ø®Ø©', 447, 0),
('Ø¨Ø¯Ø£Øª', 448, 0),
('ØªØ­Ø±ÙŠØ±Ù‡Ø§', 449, 0),
('Ø¯Ù‚ÙŠÙ‚Ø©', 450, 0),
('Ø³Ø¨ØªÙ…Ø¨Ø±', 451, 0),
('ÙÙŠ', 452, 0),
('Ù„ØµÙ†Ø¹', 453, 0),
('Ù„ØºØ©', 454, 0),
('Ù„Ù„Ø¬Ù…ÙŠØ¹ØŒ', 455, 0),
('Ù…ØªØ¹Ø¯Ø¯', 456, 0),
('Ù…Ø´Ø±ÙˆØ¹', 457, 0),
('Ù…Ù†', 458, 0),
('Ù…ÙˆØ³ÙˆØ¹Ø©', 459, 0),
('ÙˆÙ…ØªÙƒØ§Ù…Ù„Ø©', 460, 0),
('ÙˆÙ…ØªÙ†ÙˆØ¹Ø©', 461, 0),
('ÙˆÙ…Ø¬Ø§Ù†ÙŠØ©', 462, 0),
('ÙˆÙ…Ø­Ø§ÙŠØ¯Ø©', 463, 0),
('ÙˆÙ…ÙØªÙˆØ­Ø©', 464, 0),
('ÙˆÙŠÙƒÙŠØ¨ÙŠØ¯ÙŠØ§', 465, 0),
('ÙŠØ³ØªØ·ÙŠØ¹', 466, 0),
('å…·æœ‰äº†å¯¹ä¼ä¸šä¿¡ç”¨çš„é¢„æµ‹åŠŸèƒ½', 467, 0),
('å‡å°‘äº†ä¼ä¸šä¿¡ç”¨è¯„ä¼°ä¼ ç»Ÿçš„å®šæ€§æ–¹æ³•ä¸', 468, 0),
('å®žéªŒç»“æžœè¯æ˜Ž', 469, 0),
('æå‡ºäº†ç”¨äºŽä¼ä¸šä¿¡ç”¨è¯„ä¼°çš„æŒ‡æ ‡ä½“ç³»', 470, 0),
('æ ¹æ®è¿™ä¸€æŒ‡æ ‡ä½“ç³»å»ºç«‹äº†åŸºäºŽbpç¥žç»ç½‘', 471, 0),
('ç”µå­æ¸¸æˆ', 472, 0),
('ê²½í—˜ì´', 473, 0),
('ê´œížˆ', 474, 0),
('ê¸¸ê²Œ', 475, 0),
('ë„ì ì—¬', 476, 0),
('ë‹¤ë¥¸', 477, 0),
('ë„ì›€ë ê¹Œ', 478, 0),
('ë°‘ì—', 479, 0),
('ë´…ë‹ˆë‹¤', 480, 0),
('ë¶„ë“¤ê»˜ë„', 481, 0),
('ìƒ¤ì˜¤ë‹˜ê»˜ì„œ', 482, 0),
('ì‹¶ì–´', 483, 0),
('ì•ˆëœë‹¤ê³ ', 484, 0),
('ì ìš©ì´', 485, 0),
('ì œ', 486, 0),
('í•˜ì‹œê¸°ì—', 487, 0),
('í˜¹', 488, 0),
('12345', 489, 0),
('abcdef', 490, 0),
('acentÃ³', 491, 0),
('agudos', 492, 0),
('ahora', 493, 0),
('ako', 494, 0),
('anzeigen', 495, 0),
('arÄ«', 496, 0),
('auch', 497, 0),
('bulgarian', 498, 0),
('bÃ´i', 499, 0),
('caracteres', 500, 0),
('cedilha', 501, 0),
('chinese', 502, 0),
('circunflexos', 503, 0),
('con', 504, 0),
('crase', 505, 0),
('croatian', 506, 0),
('cÅ©ng', 507, 0),
('das', 508, 0),
('deutsche', 509, 0),
('dziennÄ…', 510, 0),
('dÃ©crire', 511, 0),
('english', 512, 0),
('espaÃ±ol', 513, 0),
('especias', 514, 0),
('est', 515, 0),
('esto', 516, 0),
('europÃ©ia', 517, 0),
('farsi', 518, 0),
('fig', 519, 0),
('franÃ§ais', 520, 0),
('fully', 521, 0),
('german', 522, 0),
('grau', 523, 0),
('greek', 524, 0),
('guardar', 525, 0),
('gÅ¼egÅ¼Ã³Å‚ka', 526, 0),
('hindi', 527, 0),
('hrvatski', 528, 0),
('hungarian', 529, 0),
('hvaÃ°', 530, 0),
('icelandic', 531, 0),
('incluindo', 532, 0),
('indeed', 533, 0),
('isen', 534, 0),
('japanese', 535, 0),
('jeÅ¼a', 536, 0),
('kad', 537, 0),
('kas', 538, 0),
('khÃ´ng', 539, 0),
('korean', 540, 0),
('koriste', 541, 0),
('kÃ³dovÃ¡nÃ­', 542, 0),
('latvian', 543, 0),
('latvieÅ¡u', 544, 0),
('lietuviÅ¡kos', 545, 0),
('lithuanian', 546, 0),
('lub', 547, 0),
('luva', 548, 0),
('lÃ­ngua', 549, 0),
('med', 550, 0),
('mes', 551, 0),
('moeda', 552, 0),
('mora', 553, 0),
('muÃŸ', 554, 0),
('nekdaj', 555, 0),
('nhÆ°ng', 556, 0),
('njegovo', 557, 0),
('nocna', 558, 0),
('ordinais', 559, 0),
('osiem', 560, 0),
('pchnÄ…Ä‡', 561, 0),
('pequeÃ±o', 562, 0),
('persian', 563, 0),
('pisanje', 564, 0),
('podrÅ¾an', 565, 0),
('podrÅ¾ava', 566, 0),
('podrÅ¾avati', 567, 0),
('polish', 568, 0),
('portuguesa', 569, 0),
('portuguese', 570, 0),
('possible', 571, 0),
('possÃ­vel', 572, 0),
('problÃ©m', 573, 0),
('przekuka', 574, 0),
('puÅ¡Äa', 575, 0),
('pÃ¥', 576, 0),
('raidÄ—s', 577, 0),
('raskar', 578, 0),
('richtig', 579, 0),
('russian', 580, 0),
('rÃ¤ven', 581, 0),
('sagÃ°i', 582, 0),
('scharfe', 583, 0),
('se', 584, 0),
('search', 585, 0),
('serbian', 586, 0),
('simplified', 587, 0),
('sjÃ¡Ã°u', 588, 0),
('skrzyÅ„', 589, 0),
('slovenian', 590, 0),
('slovenski', 591, 0),
('spanish', 592, 0),
('srpski', 593, 0),
('strÄdÄ', 594, 0),
('stÃ³r', 595, 0),
('sudalyvaukime', 596, 0),
('suhi', 597, 0),
('supports', 598, 0),
('swedish', 599, 0),
('sÃ­mbolo', 600, 0),
('sÃ­na', 601, 0),
('texto', 602, 0),
('thai', 603, 0),
('thÃ¬', 604, 0),
('tie', 605, 0),
('til', 606, 0),
('tiáº¿ng', 607, 0),
('trac', 608, 0),
('tracwiki', 609, 0),
('traditional', 610, 0),
('trema', 611, 0),
('tÃ¼kÃ¶rfÃºrÃ³gÃ©p', 612, 0),
('tÄ™', 613, 0),
('tá»«', 614, 0),
('ukrainian', 615, 0),
('umlaute', 616, 0),
('un', 617, 0),
('una', 618, 0),
('und', 619, 0),
('uprkos', 620, 0),
('urdu', 621, 0),
('utf8', 622, 0),
('utf8ØŒ', 623, 0),
('valoda', 624, 0),
('veikia', 625, 0),
('vietnamese', 626, 0),
('viÃ°', 627, 0),
('viáº¿t', 628, 0),
('viá»‡t', 629, 0),
('vodo', 630, 0),
('vÃ ng', 631, 0),
('zawsze', 632, 0),
('ÂªÂº', 633, 0),
('Â°Â¹Â²Â³', 634, 0),
('ÃrvÃ­ztÅ±rÅ‘', 635, 0),
('Ã†var', 636, 0),
('Ã¡Ã©Ã­Ã³Ãº', 637, 0),
('Ã¢ÃªÃ´', 638, 0),
('Ã£Ãµ', 639, 0),
('Ã©g', 640, 0),
('Ã¶mmu', 641, 0),
('Ã¶ver', 642, 0),
('Ä„ÄŒÄ˜Ä–Ä®Å Å²ÅªÅ½', 643, 0),
('Ä…ÄÄ™Ä—Ä¯Å¡Å³Å«Å¾', 644, 0),
('ÄŒesky', 645, 0),
('ÄŒeÅ¡tina', 646, 0),
('ÄŒÄ†Å½Å Ä', 647, 0),
('Äinjenici', 648, 0),
('ÄÄ‡Å¾Å¡Ä‘', 649, 0),
('Ä‘Æ°á»£c', 650, 0),
('Å‚Ã³dÅº', 651, 0),
('Å¡kafec', 652, 0),
('Å½inoma', 653, 0),
('Å¾e', 654, 0),
('Å¾Ã¡dnÃ½', 655, 0),
('Î•Î»Î»Î·Î½Î¹ÎºÎ¬', 656, 0),
('Î¤Î±', 657, 0),
('ÎµÏ€Î¯ÏƒÎ·Ï‚', 658, 0),
('ÎµÏ€Î±ÏÎºÏŽÏ‚', 659, 0),
('ÐŸÐµÑ€ÐµÐ²Ñ–Ñ€ÐºÐ°', 660, 0),
('ÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ°', 661, 0),
('Ð°Ð»Ñ„Ð°Ð±ÐµÑ‚Ð°', 662, 0),
('Ð±ÑƒÐºÐ²Ð°', 663, 0),
('Ð´Ð²Ð°', 664, 0),
('ÐµÐ·Ð¸Ðº', 665, 0),
('ÐµÑÑ‚ÑŒ', 666, 0),
('ÐºÐ°Ð¶ÐµÑ‚ÑÑ', 667, 0),
('Ð»Ð¸', 668, 0),
('Ð¼Ð¾Ð²Ð¸', 669, 0),
('Ñ€Ð°Ð±Ð¾Ñ‚Ð°ÐµÑ‚', 670, 0),
('Ñ€Ð°Ð±Ð¾Ñ‚Ð¸', 671, 0),
('Ñ€ÑƒÑÑÐºÐ¾Ð³Ð¾', 672, 0),
('Ñ‡Ð°Ðº', 673, 0),
('ÑÐ·Ñ‹ÐºÐ°', 674, 0),
('×× ×™', 675, 0),
('×•×–×”', 676, 0),
('×–×›×•×›×™×ª', 677, 0),
('×™×›×•×œ', 678, 0),
('×œ×', 679, 0),
('×œ××›×•×œ', 680, 0),
('×œ×™', 681, 0),
('×ž×–×™×§', 682, 0),
('Ø§Ø±Ø¯Ùˆ', 683, 0),
('Ø§Ø²', 684, 0),
('Ø§Ø³Øª', 685, 0),
('Ø§Ø³ØªÙØ§Ø¯Ù‡', 686, 0),
('Ø§Ø¹Ø¯Ø§Ø¯', 687, 0),
('Ø§Ù„ØªÙŠÙƒØª', 688, 0),
('Ø§Ù„ÙƒÙ„Ù…Ø§Øª', 689, 0),
('Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…Ø©', 690, 0),
('Ø§Ù…Ú©Ø§Ù†', 691, 0),
('Ø§ÛŒÙ†', 692, 0),
('Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù…', 693, 0),
('Ø¨Ø§ÛŒØ¯', 694, 0),
('Ø¨Ø­ÙØ¸', 695, 0),
('Ø¨Ø±Ø§ÛŒ', 696, 0),
('Ø¨Ù…Ø§', 697, 0),
('Ø¨Ù‡', 698, 0),
('Ø¨Ú¾ÛŒ', 699, 0),
('ØªØ§', 700, 0),
('ØªØ±Ø§Ùƒ', 701, 0),
('Ø¬ÙˆØ¯', 702, 0),
('Ø­Ø§Ù„Øª', 703, 0),
('Ø­Ø±ÙˆÙ', 704, 0),
('Ø®ÙˆØ¯Ø´Ø§Ù†', 705, 0),
('Ø¯Ø§Ø¯Ù‡', 706, 0),
('Ø¯Ø±', 707, 0),
('Ø°Ù„Ùƒ', 708, 0),
('Ø±Ø§Ø³Øª', 709, 0),
('Ø³Ù¾ÙˆØ±Ù¹', 710, 0),
('Ø´Ø¯Ù‡', 711, 0),
('Ø´ÙˆÙ†Ø¯', 712, 0),
('ØµÙØ­Ø§Øª', 713, 0),
('ØµÙŠØºØ©', 714, 0),
('ÙØ§Ø±Ø³ÛŒ', 715, 0),
('ÙƒÙ„', 716, 0),
('Ù„Ø§ØªÛŒÙ†', 717, 0),
('Ù…ØªÙ†', 718, 0),
('Ù…Ø­Ù„', 719, 0),
('Ù…Ø³ØªÙ‚ÛŒÙ…', 720, 0),
('Ù†Ø¯Ø§Ø±Ø¯', 721, 0),
('Ù†Ù…Ø§ÛŒØ´', 722, 0),
('Ù†Ù…ÙˆÙ†Ù‡', 723, 0),
('Ù†ÙˆØ´ØªÙ†', 724, 0),
('Ù†ÙˆØ´ØªÙ‡', 725, 0),
('Ù†ÛŒØ³Øª', 726, 0),
('ÙˆØ§Ù„ÙˆÙŠÙƒÙŠ', 727, 0),
('ÙˆÙ„ÛŒ', 728, 0),
('ÙŠÙ‚ÙˆÙ…', 729, 0),
('Ù¹Ø±ÛŒÚ©', 730, 0),
('Ú†ÙˆÙ†', 731, 0),
('Ú†Ù¾', 732, 0),
('Ú©Ø±ØªØ§', 733, 0),
('Ú©Ù†ÛŒØ¯', 734, 0),
('Ú©Ù‡', 735, 0),
('ÛÛ’Û”', 736, 0),
('ÛŒÚ©', 737, 0),
('à¤…à¤¬', 738, 0),
('à¤®à¥‡à¤‚à¥¤', 739, 0),
('à¤¹à¤¿à¤¨à¥à¤¦à¥€', 740, 0),
('â‚¬', 741, 0),
('ã²ã‚‰ãŒãª', 742, 0),
('ã‚«ã‚¿ã‚«ãƒŠ', 743, 0),
('æ—¥æœ¬èªžè©¦é¨“', 744, 0),
('æ¼¢å­—', 745, 0),
('æ¼¢å­—æ¸¬è©¦', 746, 0),
('ç¹é«”ä¸­æ–‡', 747, 0),
('ë³´ì´ë‚˜ìš”', 748, 0),
('ì¨ë³´ê² ìŠµë‹ˆë‹¤', 749, 0),
('ì´ë²ˆì—ëŠ”', 750, 0),
('ìž˜', 751, 0),
('í•œê¸€', 752, 0),
('í•œê¸€ë¡œ', 753, 0),
('ï¾Šï¾ï½¶ï½¸ï½¶ï¾…', 754, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_search_wordmatch`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_search_wordmatch` (
  `post_id` mediumint(8) unsigned NOT NULL,
  `word_id` mediumint(8) unsigned NOT NULL,
  `title_match` tinyint(1) NOT NULL,
  KEY `post_id` (`post_id`),
  KEY `word_id` (`word_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_search_wordmatch`
-- 

INSERT INTO `phpbb_search_wordmatch` (`post_id`, `word_id`, `title_match`) VALUES 
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(1, 11, 0),
(1, 12, 1),
(1, 3, 1),
(2, 13, 1),
(3, 15, 0),
(3, 17, 0),
(3, 18, 0),
(3, 14, 1),
(3, 16, 1),
(4, 17, 0),
(4, 19, 0),
(4, 20, 0),
(4, 13, 1),
(5, 21, 0),
(5, 21, 1),
(6, 22, 0),
(6, 22, 1),
(7, 24, 0),
(7, 23, 1),
(9, 2, 0),
(9, 25, 0),
(9, 26, 0),
(9, 28, 0),
(9, 30, 0),
(9, 32, 0),
(9, 27, 1),
(9, 29, 1),
(9, 31, 1),
(10, 26, 0),
(10, 33, 1),
(10, 34, 1),
(11, 65, 0),
(11, 58, 0),
(11, 59, 0),
(11, 60, 0),
(11, 61, 0),
(11, 62, 0),
(11, 63, 0),
(11, 36, 0),
(11, 64, 0),
(11, 30, 0),
(11, 28, 0),
(11, 26, 0),
(11, 5, 0),
(11, 2, 0),
(12, 43, 0),
(12, 44, 0),
(12, 45, 0),
(12, 46, 0),
(12, 44, 1),
(12, 46, 1),
(13, 55, 0),
(13, 54, 0),
(13, 51, 0),
(13, 52, 0),
(13, 53, 0),
(13, 47, 0),
(13, 17, 0),
(13, 56, 0),
(13, 57, 0),
(13, 47, 1),
(13, 17, 1),
(14, 47, 0),
(14, 53, 0),
(14, 55, 0),
(14, 56, 0),
(14, 17, 0),
(14, 47, 1),
(14, 17, 1),
(11, 36, 1),
(15, 2, 0),
(15, 6, 0),
(15, 14, 0),
(15, 16, 0),
(15, 61, 0),
(15, 60, 0),
(15, 52, 0),
(15, 66, 0),
(15, 67, 0),
(15, 68, 0),
(15, 69, 0),
(15, 70, 0),
(15, 71, 0),
(15, 72, 0),
(15, 73, 0),
(15, 74, 0),
(15, 75, 0),
(15, 76, 0),
(15, 77, 0),
(15, 78, 0),
(15, 79, 0),
(15, 80, 0),
(15, 81, 0),
(15, 82, 0),
(15, 83, 0),
(15, 84, 0),
(15, 85, 0),
(15, 86, 0),
(15, 87, 0),
(15, 88, 0),
(15, 89, 0),
(15, 90, 0),
(15, 91, 0),
(15, 92, 0),
(15, 93, 0),
(15, 94, 0),
(15, 95, 0),
(15, 96, 0),
(15, 97, 0),
(15, 98, 0),
(15, 99, 0),
(15, 100, 0),
(15, 102, 0),
(15, 101, 1),
(16, 17, 0),
(16, 54, 0),
(16, 104, 0),
(16, 105, 0),
(16, 106, 0),
(16, 107, 0),
(16, 108, 0),
(16, 109, 0),
(16, 110, 0),
(16, 111, 0),
(16, 112, 0),
(16, 113, 0),
(16, 115, 0),
(16, 103, 1),
(16, 114, 1),
(22, 195, 1),
(22, 237, 0),
(22, 236, 0),
(22, 192, 0),
(22, 235, 0),
(22, 234, 0),
(17, 17, 1),
(17, 160, 1),
(17, 179, 0),
(17, 17, 0),
(17, 203, 0),
(17, 202, 0),
(17, 201, 0),
(17, 200, 0),
(17, 199, 0),
(22, 233, 0),
(22, 232, 0),
(21, 195, 1),
(21, 231, 0),
(21, 230, 0),
(18, 17, 1),
(18, 160, 1),
(18, 204, 0),
(18, 205, 0),
(18, 148, 0),
(18, 206, 0),
(18, 207, 0),
(18, 208, 0),
(18, 209, 0),
(18, 210, 0),
(18, 211, 0),
(18, 212, 0),
(18, 213, 0),
(18, 214, 0),
(18, 215, 0),
(18, 216, 0),
(18, 217, 0),
(18, 218, 0),
(18, 219, 0),
(18, 220, 0),
(18, 221, 0),
(18, 222, 0),
(18, 223, 0),
(18, 107, 0),
(18, 54, 0),
(18, 45, 0),
(21, 229, 0),
(21, 228, 0),
(21, 227, 0),
(21, 226, 0),
(21, 225, 0),
(21, 224, 0),
(19, 17, 1),
(19, 148, 0),
(19, 17, 0),
(18, 30, 0),
(18, 17, 0),
(17, 198, 0),
(17, 116, 0),
(20, 17, 0),
(20, 104, 0),
(20, 107, 0),
(20, 113, 0),
(20, 179, 0),
(20, 181, 0),
(20, 182, 0),
(20, 183, 0),
(20, 184, 0),
(20, 185, 0),
(20, 186, 0),
(20, 187, 0),
(20, 188, 0),
(20, 189, 0),
(20, 190, 0),
(20, 191, 0),
(20, 192, 0),
(20, 193, 0),
(20, 194, 0),
(20, 195, 0),
(20, 196, 0),
(20, 197, 0),
(20, 180, 1),
(23, 238, 0),
(23, 226, 0),
(23, 239, 0),
(23, 240, 0),
(23, 241, 0),
(23, 195, 1),
(24, 242, 0),
(24, 243, 0),
(24, 244, 0),
(24, 226, 0),
(24, 245, 0),
(24, 246, 0),
(24, 247, 0),
(24, 248, 0),
(24, 195, 0),
(24, 195, 1),
(25, 249, 0),
(25, 250, 0),
(25, 251, 0),
(25, 252, 0),
(25, 231, 0),
(25, 195, 1),
(26, 253, 0),
(26, 254, 0),
(26, 255, 0),
(26, 226, 0),
(26, 256, 0),
(26, 257, 0),
(26, 258, 0),
(26, 195, 1),
(27, 259, 0),
(27, 260, 0),
(27, 261, 0),
(27, 262, 0),
(27, 263, 0),
(27, 86, 0),
(27, 264, 0),
(27, 231, 0),
(27, 265, 0),
(27, 195, 0),
(27, 195, 1),
(28, 266, 0),
(28, 267, 0),
(28, 268, 0),
(28, 269, 0),
(28, 262, 0),
(28, 270, 0),
(28, 271, 0),
(28, 263, 0),
(28, 272, 0),
(28, 273, 0),
(28, 274, 0),
(28, 275, 0),
(28, 195, 1),
(29, 276, 0),
(29, 226, 0),
(29, 277, 0),
(29, 256, 0),
(29, 81, 0),
(29, 278, 0),
(29, 195, 0),
(29, 195, 1),
(30, 279, 0),
(30, 280, 0),
(30, 281, 0),
(30, 282, 0),
(30, 283, 0),
(30, 284, 0),
(30, 285, 0),
(30, 286, 0),
(30, 231, 0),
(30, 287, 0),
(30, 288, 0),
(30, 265, 0),
(30, 148, 0),
(30, 194, 0),
(30, 195, 1),
(31, 290, 0),
(31, 72, 0),
(31, 291, 0),
(31, 292, 0),
(31, 293, 0),
(31, 79, 0),
(31, 81, 0),
(31, 83, 0),
(31, 294, 0),
(31, 295, 0),
(31, 296, 0),
(31, 17, 0),
(31, 113, 0),
(31, 289, 1),
(32, 297, 0),
(32, 298, 0),
(32, 291, 0),
(32, 7, 0),
(32, 299, 0),
(32, 300, 0),
(32, 220, 0),
(32, 301, 0),
(32, 296, 0),
(32, 17, 0),
(32, 302, 0),
(32, 303, 0),
(32, 97, 0),
(32, 304, 0),
(32, 291, 1),
(32, 296, 1),
(33, 305, 0),
(33, 307, 0),
(33, 308, 0),
(33, 309, 0),
(33, 290, 0),
(33, 293, 0),
(33, 310, 0),
(33, 311, 0),
(33, 81, 0),
(33, 312, 0),
(33, 190, 0),
(33, 235, 0),
(33, 17, 0),
(33, 18, 0),
(33, 313, 0),
(33, 306, 1),
(33, 290, 1),
(33, 18, 1),
(34, 72, 0),
(34, 292, 0),
(34, 315, 0),
(34, 17, 0),
(34, 316, 0),
(34, 317, 0),
(34, 318, 0),
(34, 314, 1),
(34, 319, 1),
(35, 321, 0),
(35, 322, 0),
(35, 323, 0),
(35, 324, 0),
(35, 325, 0),
(35, 326, 0),
(35, 191, 0),
(35, 327, 0),
(35, 328, 0),
(35, 275, 0),
(35, 320, 1),
(35, 328, 1),
(36, 330, 0),
(36, 72, 0),
(36, 292, 0),
(36, 331, 0),
(36, 52, 0),
(36, 332, 0),
(36, 333, 0),
(36, 334, 0),
(36, 335, 0),
(36, 81, 0),
(36, 336, 0),
(36, 337, 0),
(36, 189, 0),
(36, 338, 0),
(36, 109, 0),
(36, 112, 0),
(36, 339, 0),
(36, 17, 0),
(36, 193, 0),
(36, 340, 0),
(36, 341, 0),
(36, 329, 1),
(36, 112, 1),
(37, 52, 0),
(37, 342, 0),
(37, 343, 0),
(37, 345, 0),
(37, 190, 0),
(37, 217, 0),
(37, 17, 0),
(37, 340, 0),
(37, 344, 1),
(37, 346, 1),
(37, 340, 1),
(38, 347, 0),
(38, 348, 0),
(38, 349, 0),
(38, 297, 0),
(38, 4, 0),
(38, 350, 0),
(38, 351, 0),
(38, 347, 1),
(38, 297, 1),
(38, 350, 1),
(38, 352, 1),
(39, 105, 0),
(39, 353, 0),
(39, 292, 0),
(39, 354, 0),
(39, 355, 0),
(39, 300, 0),
(39, 350, 0),
(39, 356, 0),
(39, 257, 0),
(39, 357, 0),
(39, 354, 1),
(39, 300, 1),
(39, 350, 1),
(40, 255, 0),
(40, 292, 0),
(40, 354, 0),
(40, 358, 0),
(40, 359, 0),
(40, 199, 0),
(40, 9, 0),
(40, 108, 0),
(40, 262, 0),
(40, 360, 0),
(40, 350, 0),
(40, 361, 0),
(40, 362, 0),
(40, 257, 0),
(40, 363, 0),
(40, 284, 0),
(40, 190, 0),
(40, 17, 0),
(40, 303, 0),
(40, 365, 0),
(40, 366, 0),
(40, 265, 0),
(40, 367, 0),
(40, 350, 1),
(40, 364, 1),
(41, 52, 0),
(41, 342, 0),
(41, 343, 0),
(41, 336, 0),
(41, 345, 0),
(41, 190, 0),
(41, 217, 0),
(41, 17, 0),
(41, 336, 1),
(41, 344, 1),
(41, 346, 1),
(42, 396, 0),
(42, 395, 0),
(42, 18, 0),
(42, 203, 0),
(42, 394, 0),
(42, 54, 0),
(42, 393, 0),
(42, 392, 0),
(42, 391, 0),
(42, 390, 0),
(42, 389, 0),
(42, 388, 0),
(42, 387, 0),
(42, 386, 0),
(42, 385, 0),
(42, 384, 0),
(42, 383, 0),
(42, 368, 0),
(42, 397, 0),
(42, 398, 0),
(42, 399, 0),
(42, 400, 0),
(42, 368, 1),
(43, 91, 0),
(43, 203, 0),
(43, 313, 0),
(43, 401, 0),
(43, 402, 0),
(43, 404, 0),
(43, 405, 0),
(43, 406, 0),
(43, 407, 0),
(43, 408, 0),
(43, 409, 0),
(43, 410, 0),
(43, 411, 0),
(43, 412, 0),
(43, 413, 0),
(43, 414, 0),
(43, 415, 0),
(43, 416, 0),
(43, 417, 0),
(43, 418, 0),
(43, 420, 0),
(43, 421, 0),
(43, 422, 0),
(43, 423, 0),
(43, 424, 0),
(43, 425, 0),
(43, 426, 0),
(43, 427, 0),
(43, 428, 0),
(43, 429, 0),
(43, 430, 0),
(43, 431, 0),
(43, 432, 0),
(43, 433, 0),
(43, 434, 0),
(43, 435, 0),
(43, 436, 0),
(43, 437, 0),
(43, 438, 0),
(43, 439, 0),
(43, 440, 0),
(43, 441, 0),
(43, 442, 0),
(43, 443, 0),
(43, 444, 0),
(43, 445, 0),
(43, 446, 0),
(43, 447, 0),
(43, 448, 0),
(43, 449, 0),
(43, 450, 0),
(43, 451, 0),
(43, 452, 0),
(43, 453, 0),
(43, 454, 0),
(43, 455, 0),
(43, 456, 0),
(43, 457, 0),
(43, 458, 0),
(43, 459, 0),
(43, 460, 0),
(43, 461, 0),
(43, 462, 0),
(43, 463, 0),
(43, 464, 0),
(43, 465, 0),
(43, 466, 0),
(43, 467, 0),
(43, 469, 0),
(43, 470, 0),
(43, 472, 0),
(43, 473, 0),
(43, 474, 0),
(43, 475, 0),
(43, 476, 0),
(43, 477, 0),
(43, 478, 0),
(43, 479, 0),
(43, 480, 0),
(43, 481, 0),
(43, 482, 0),
(43, 483, 0),
(43, 484, 0),
(43, 485, 0),
(43, 486, 0),
(43, 487, 0),
(43, 488, 0),
(43, 403, 1),
(43, 419, 1),
(43, 18, 1),
(44, 18, 0),
(44, 18, 1),
(45, 203, 0),
(45, 402, 0),
(45, 407, 0),
(45, 408, 0),
(45, 452, 0),
(45, 489, 0),
(45, 490, 0),
(45, 491, 0),
(45, 492, 0),
(45, 493, 0),
(45, 494, 0),
(45, 495, 0),
(45, 496, 0),
(45, 497, 0),
(45, 498, 0),
(45, 499, 0),
(45, 500, 0),
(45, 501, 0),
(45, 502, 0),
(45, 503, 0),
(45, 504, 0),
(45, 505, 0),
(45, 506, 0),
(45, 507, 0),
(45, 508, 0),
(45, 509, 0),
(45, 510, 0),
(45, 511, 0),
(45, 512, 0),
(45, 513, 0),
(45, 514, 0),
(45, 515, 0),
(45, 516, 0),
(45, 517, 0),
(45, 518, 0),
(45, 519, 0),
(45, 520, 0),
(45, 521, 0),
(45, 522, 0),
(45, 523, 0),
(45, 524, 0),
(45, 525, 0),
(45, 526, 0),
(45, 527, 0),
(45, 528, 0),
(45, 529, 0),
(45, 530, 0),
(45, 531, 0),
(45, 532, 0),
(45, 533, 0),
(45, 534, 0),
(45, 535, 0),
(45, 536, 0),
(45, 537, 0),
(45, 538, 0),
(45, 539, 0),
(45, 540, 0),
(45, 541, 0),
(45, 542, 0),
(45, 543, 0),
(45, 544, 0),
(45, 545, 0),
(45, 546, 0),
(45, 547, 0),
(45, 548, 0),
(45, 549, 0),
(45, 550, 0),
(45, 551, 0),
(45, 552, 0),
(45, 553, 0),
(45, 554, 0),
(45, 555, 0),
(45, 556, 0),
(45, 557, 0),
(45, 558, 0),
(45, 559, 0),
(45, 560, 0),
(45, 561, 0),
(45, 562, 0),
(45, 563, 0),
(45, 564, 0),
(45, 565, 0),
(45, 566, 0),
(45, 567, 0),
(45, 568, 0),
(45, 569, 0),
(45, 570, 0),
(45, 571, 0),
(45, 572, 0),
(45, 573, 0),
(45, 574, 0),
(45, 575, 0),
(45, 576, 0),
(45, 577, 0),
(45, 578, 0),
(45, 579, 0),
(45, 580, 0),
(45, 581, 0),
(45, 582, 0),
(45, 583, 0),
(45, 584, 0),
(45, 585, 0),
(45, 586, 0),
(45, 587, 0),
(45, 588, 0),
(45, 589, 0),
(45, 590, 0),
(45, 591, 0),
(45, 592, 0),
(45, 593, 0),
(45, 594, 0),
(45, 595, 0),
(45, 596, 0),
(45, 597, 0),
(45, 598, 0),
(45, 599, 0),
(45, 600, 0),
(45, 601, 0),
(45, 602, 0),
(45, 603, 0),
(45, 604, 0),
(45, 605, 0),
(45, 606, 0),
(45, 607, 0),
(45, 608, 0),
(45, 609, 0),
(45, 610, 0),
(45, 611, 0),
(45, 612, 0),
(45, 613, 0),
(45, 614, 0),
(45, 615, 0),
(45, 616, 0),
(45, 617, 0),
(45, 618, 0),
(45, 619, 0),
(45, 620, 0),
(45, 621, 0),
(45, 622, 0),
(45, 623, 0),
(45, 624, 0),
(45, 625, 0),
(45, 626, 0),
(45, 627, 0),
(45, 628, 0),
(45, 629, 0),
(45, 630, 0),
(45, 631, 0),
(45, 632, 0),
(45, 633, 0),
(45, 634, 0),
(45, 635, 0),
(45, 636, 0),
(45, 637, 0),
(45, 638, 0),
(45, 639, 0),
(45, 640, 0),
(45, 641, 0),
(45, 642, 0),
(45, 643, 0),
(45, 644, 0),
(45, 645, 0),
(45, 646, 0),
(45, 647, 0),
(45, 648, 0),
(45, 649, 0),
(45, 650, 0),
(45, 651, 0),
(45, 652, 0),
(45, 653, 0),
(45, 654, 0),
(45, 655, 0),
(45, 656, 0),
(45, 657, 0),
(45, 658, 0),
(45, 659, 0),
(45, 660, 0),
(45, 661, 0),
(45, 662, 0),
(45, 663, 0),
(45, 664, 0),
(45, 665, 0),
(45, 666, 0),
(45, 667, 0),
(45, 668, 0),
(45, 669, 0),
(45, 670, 0),
(45, 671, 0),
(45, 672, 0),
(45, 673, 0),
(45, 674, 0),
(45, 675, 0),
(45, 676, 0),
(45, 677, 0),
(45, 678, 0),
(45, 679, 0),
(45, 680, 0),
(45, 681, 0),
(45, 682, 0),
(45, 683, 0),
(45, 684, 0),
(45, 685, 0),
(45, 686, 0),
(45, 687, 0),
(45, 688, 0),
(45, 689, 0),
(45, 690, 0),
(45, 691, 0),
(45, 692, 0),
(45, 693, 0),
(45, 694, 0),
(45, 695, 0),
(45, 696, 0),
(45, 697, 0),
(45, 698, 0),
(45, 699, 0),
(45, 700, 0),
(45, 701, 0),
(45, 702, 0),
(45, 703, 0),
(45, 704, 0),
(45, 705, 0),
(45, 706, 0),
(45, 707, 0),
(45, 708, 0),
(45, 709, 0),
(45, 710, 0),
(45, 711, 0),
(45, 712, 0),
(45, 713, 0),
(45, 714, 0),
(45, 715, 0),
(45, 716, 0),
(45, 717, 0),
(45, 718, 0),
(45, 719, 0),
(45, 720, 0),
(45, 721, 0),
(45, 722, 0),
(45, 723, 0),
(45, 724, 0),
(45, 725, 0),
(45, 726, 0),
(45, 727, 0),
(45, 728, 0),
(45, 729, 0),
(45, 730, 0),
(45, 731, 0),
(45, 732, 0),
(45, 733, 0),
(45, 734, 0),
(45, 735, 0),
(45, 736, 0),
(45, 737, 0),
(45, 738, 0),
(45, 739, 0),
(45, 740, 0),
(45, 741, 0),
(45, 742, 0),
(45, 743, 0),
(45, 744, 0),
(45, 745, 0),
(45, 746, 0),
(45, 747, 0),
(45, 748, 0),
(45, 749, 0),
(45, 750, 0),
(45, 751, 0),
(45, 752, 0),
(45, 753, 0),
(45, 754, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_sessions`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_sessions` (
  `session_id` char(32) NOT NULL,
  `session_user_id` mediumint(8) NOT NULL,
  `session_start` int(11) NOT NULL,
  `session_time` int(11) NOT NULL,
  `session_ip` char(8) NOT NULL,
  `session_page` int(11) NOT NULL,
  `session_logged_in` tinyint(1) NOT NULL,
  `session_admin` tinyint(2) NOT NULL,
  PRIMARY KEY  (`session_id`),
  KEY `session_user_id` (`session_user_id`),
  KEY `session_id_ip_user_id` (`session_id`,`session_ip`,`session_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_sessions`
-- 

INSERT INTO `phpbb_sessions` (`session_id`, `session_user_id`, `session_start`, `session_time`, `session_ip`, `session_page`, `session_logged_in`, `session_admin`) VALUES 
('ea0d6465cfe6d1889851fd43526c78e9', -1, 1193265050, 1193347455, '7f000001', 0, 0, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_sessions_keys`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_sessions_keys` (
  `key_id` varchar(32) NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  `last_ip` varchar(8) NOT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY  (`key_id`,`user_id`),
  KEY `last_login` (`last_login`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_sessions_keys`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_smilies`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_smilies` (
  `smilies_id` smallint(5) unsigned NOT NULL auto_increment,
  `code` varchar(50) default NULL,
  `smile_url` varchar(100) default NULL,
  `emoticon` varchar(75) default NULL,
  PRIMARY KEY  (`smilies_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_smilies`
-- 

INSERT INTO `phpbb_smilies` (`smilies_id`, `code`, `smile_url`, `emoticon`) VALUES 
(1, ':D', 'icon_biggrin.gif', 'Very Happy'),
(2, ':-D', 'icon_biggrin.gif', 'Very Happy'),
(3, ':grin:', 'icon_biggrin.gif', 'Very Happy'),
(4, ':)', 'icon_smile.gif', 'Smile'),
(5, ':-)', 'icon_smile.gif', 'Smile'),
(6, ':smile:', 'icon_smile.gif', 'Smile'),
(7, ':(', 'icon_sad.gif', 'Sad'),
(8, ':-(', 'icon_sad.gif', 'Sad'),
(9, ':sad:', 'icon_sad.gif', 'Sad'),
(10, ':o', 'icon_surprised.gif', 'Surprised'),
(11, ':-o', 'icon_surprised.gif', 'Surprised'),
(12, ':eek:', 'icon_surprised.gif', 'Surprised'),
(13, ':shock:', 'icon_eek.gif', 'Shocked'),
(14, ':?', 'icon_confused.gif', 'Confused'),
(15, ':-?', 'icon_confused.gif', 'Confused'),
(16, ':???:', 'icon_confused.gif', 'Confused'),
(17, '8)', 'icon_cool.gif', 'Cool'),
(18, '8-)', 'icon_cool.gif', 'Cool'),
(19, ':cool:', 'icon_cool.gif', 'Cool'),
(20, ':lol:', 'icon_lol.gif', 'Laughing'),
(21, ':x', 'icon_mad.gif', 'Mad'),
(22, ':-x', 'icon_mad.gif', 'Mad'),
(23, ':mad:', 'icon_mad.gif', 'Mad'),
(24, ':P', 'icon_razz.gif', 'Razz'),
(25, ':-P', 'icon_razz.gif', 'Razz'),
(26, ':razz:', 'icon_razz.gif', 'Razz'),
(27, ':oops:', 'icon_redface.gif', 'Embarassed'),
(28, ':cry:', 'icon_cry.gif', 'Crying or Very sad'),
(29, ':evil:', 'icon_evil.gif', 'Evil or Very Mad'),
(30, ':twisted:', 'icon_twisted.gif', 'Twisted Evil'),
(31, ':roll:', 'icon_rolleyes.gif', 'Rolling Eyes'),
(32, ':wink:', 'icon_wink.gif', 'Wink'),
(33, ';)', 'icon_wink.gif', 'Wink'),
(34, ';-)', 'icon_wink.gif', 'Wink'),
(35, ':!:', 'icon_exclaim.gif', 'Exclamation'),
(36, ':?:', 'icon_question.gif', 'Question'),
(37, ':idea:', 'icon_idea.gif', 'Idea'),
(38, ':arrow:', 'icon_arrow.gif', 'Arrow'),
(39, ':|', 'icon_neutral.gif', 'Neutral'),
(40, ':-|', 'icon_neutral.gif', 'Neutral'),
(41, ':neutral:', 'icon_neutral.gif', 'Neutral'),
(42, ':mrgreen:', 'icon_mrgreen.gif', 'Mr. Green');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_themes`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_themes` (
  `themes_id` mediumint(8) unsigned NOT NULL auto_increment,
  `template_name` varchar(30) NOT NULL,
  `style_name` varchar(30) NOT NULL,
  `head_stylesheet` varchar(100) default NULL,
  `body_background` varchar(100) default NULL,
  `body_bgcolor` varchar(6) default NULL,
  `body_text` varchar(6) default NULL,
  `body_link` varchar(6) default NULL,
  `body_vlink` varchar(6) default NULL,
  `body_alink` varchar(6) default NULL,
  `body_hlink` varchar(6) default NULL,
  `tr_color1` varchar(6) default NULL,
  `tr_color2` varchar(6) default NULL,
  `tr_color3` varchar(6) default NULL,
  `tr_class1` varchar(25) default NULL,
  `tr_class2` varchar(25) default NULL,
  `tr_class3` varchar(25) default NULL,
  `th_color1` varchar(6) default NULL,
  `th_color2` varchar(6) default NULL,
  `th_color3` varchar(6) default NULL,
  `th_class1` varchar(25) default NULL,
  `th_class2` varchar(25) default NULL,
  `th_class3` varchar(25) default NULL,
  `td_color1` varchar(6) default NULL,
  `td_color2` varchar(6) default NULL,
  `td_color3` varchar(6) default NULL,
  `td_class1` varchar(25) default NULL,
  `td_class2` varchar(25) default NULL,
  `td_class3` varchar(25) default NULL,
  `fontface1` varchar(50) default NULL,
  `fontface2` varchar(50) default NULL,
  `fontface3` varchar(50) default NULL,
  `fontsize1` tinyint(4) default NULL,
  `fontsize2` tinyint(4) default NULL,
  `fontsize3` tinyint(4) default NULL,
  `fontcolor1` varchar(6) default NULL,
  `fontcolor2` varchar(6) default NULL,
  `fontcolor3` varchar(6) default NULL,
  `span_class1` varchar(25) default NULL,
  `span_class2` varchar(25) default NULL,
  `span_class3` varchar(25) default NULL,
  `img_size_poll` smallint(5) unsigned default NULL,
  `img_size_privmsg` smallint(5) unsigned default NULL,
  PRIMARY KEY  (`themes_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_themes`
-- 

INSERT INTO `phpbb_themes` (`themes_id`, `template_name`, `style_name`, `head_stylesheet`, `body_background`, `body_bgcolor`, `body_text`, `body_link`, `body_vlink`, `body_alink`, `body_hlink`, `tr_color1`, `tr_color2`, `tr_color3`, `tr_class1`, `tr_class2`, `tr_class3`, `th_color1`, `th_color2`, `th_color3`, `th_class1`, `th_class2`, `th_class3`, `td_color1`, `td_color2`, `td_color3`, `td_class1`, `td_class2`, `td_class3`, `fontface1`, `fontface2`, `fontface3`, `fontsize1`, `fontsize2`, `fontsize3`, `fontcolor1`, `fontcolor2`, `fontcolor3`, `span_class1`, `span_class2`, `span_class3`, `img_size_poll`, `img_size_privmsg`) VALUES 
(1, 'subSilver', 'subSilver', 'subSilver.css', '', 'E5E5E5', '000000', '006699', '5493B4', '', 'DD6900', 'EFEFEF', 'DEE3E7', 'D1D7DC', '', '', '', '98AAB1', '006699', 'FFFFFF', 'cellpic1.gif', 'cellpic3.gif', 'cellpic2.jpg', 'FAFAFA', 'FFFFFF', '', 'row1', 'row2', '', 'Verdana, Arial, Helvetica, sans-serif', 'Trebuchet MS', 'Courier, ''Courier New'', sans-serif', 10, 11, 12, '444444', '006600', 'FFA34F', '', '', '', NULL, NULL);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_themes_name`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_themes_name` (
  `themes_id` smallint(5) unsigned NOT NULL,
  `tr_color1_name` char(50) default NULL,
  `tr_color2_name` char(50) default NULL,
  `tr_color3_name` char(50) default NULL,
  `tr_class1_name` char(50) default NULL,
  `tr_class2_name` char(50) default NULL,
  `tr_class3_name` char(50) default NULL,
  `th_color1_name` char(50) default NULL,
  `th_color2_name` char(50) default NULL,
  `th_color3_name` char(50) default NULL,
  `th_class1_name` char(50) default NULL,
  `th_class2_name` char(50) default NULL,
  `th_class3_name` char(50) default NULL,
  `td_color1_name` char(50) default NULL,
  `td_color2_name` char(50) default NULL,
  `td_color3_name` char(50) default NULL,
  `td_class1_name` char(50) default NULL,
  `td_class2_name` char(50) default NULL,
  `td_class3_name` char(50) default NULL,
  `fontface1_name` char(50) default NULL,
  `fontface2_name` char(50) default NULL,
  `fontface3_name` char(50) default NULL,
  `fontsize1_name` char(50) default NULL,
  `fontsize2_name` char(50) default NULL,
  `fontsize3_name` char(50) default NULL,
  `fontcolor1_name` char(50) default NULL,
  `fontcolor2_name` char(50) default NULL,
  `fontcolor3_name` char(50) default NULL,
  `span_class1_name` char(50) default NULL,
  `span_class2_name` char(50) default NULL,
  `span_class3_name` char(50) default NULL,
  PRIMARY KEY  (`themes_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_themes_name`
-- 

INSERT INTO `phpbb_themes_name` (`themes_id`, `tr_color1_name`, `tr_color2_name`, `tr_color3_name`, `tr_class1_name`, `tr_class2_name`, `tr_class3_name`, `th_color1_name`, `th_color2_name`, `th_color3_name`, `th_class1_name`, `th_class2_name`, `th_class3_name`, `td_color1_name`, `td_color2_name`, `td_color3_name`, `td_class1_name`, `td_class2_name`, `td_class3_name`, `fontface1_name`, `fontface2_name`, `fontface3_name`, `fontsize1_name`, `fontsize2_name`, `fontsize3_name`, `fontcolor1_name`, `fontcolor2_name`, `fontcolor3_name`, `span_class1_name`, `span_class2_name`, `span_class3_name`) VALUES 
(1, 'The lightest row colour', 'The medium row color', 'The darkest row colour', '', '', '', 'Border round the whole page', 'Outer table border', 'Inner table border', 'Silver gradient picture', 'Blue gradient picture', 'Fade-out gradient on index', 'Background for quote boxes', 'All white areas', '', 'Background for topic posts', '2nd background for topic posts', '', 'Main fonts', 'Additional topic title font', 'Form fonts', 'Smallest font size', 'Medium font size', 'Normal font size (post body etc)', 'Quote & copyright text', 'Code text colour', 'Main table header text colour', '', '', '');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_topics`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_topics` (
  `topic_id` mediumint(8) unsigned NOT NULL auto_increment,
  `forum_id` smallint(8) unsigned NOT NULL,
  `topic_title` char(60) NOT NULL,
  `topic_poster` mediumint(8) NOT NULL,
  `topic_time` int(11) NOT NULL,
  `topic_views` mediumint(8) unsigned NOT NULL,
  `topic_replies` mediumint(8) unsigned NOT NULL,
  `topic_status` tinyint(3) NOT NULL,
  `topic_vote` tinyint(1) NOT NULL,
  `topic_type` tinyint(3) NOT NULL,
  `topic_first_post_id` mediumint(8) unsigned NOT NULL,
  `topic_last_post_id` mediumint(8) unsigned NOT NULL,
  `topic_moved_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`topic_id`),
  KEY `forum_id` (`forum_id`),
  KEY `topic_moved_id` (`topic_moved_id`),
  KEY `topic_status` (`topic_status`),
  KEY `topic_type` (`topic_type`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_topics`
-- 

INSERT INTO `phpbb_topics` (`topic_id`, `forum_id`, `topic_title`, `topic_poster`, `topic_time`, `topic_views`, `topic_replies`, `topic_status`, `topic_vote`, `topic_type`, `topic_first_post_id`, `topic_last_post_id`, `topic_moved_id`) VALUES 
(1, 1, 'Welcome to phpBB 2', 2, 972086460, 8, 0, 0, 0, 0, 1, 1, 0),
(2, 2, 'News Item', 2, 1180968079, 7, 0, 0, 0, 0, 2, 2, 0),
(3, 1, 'Front page discription', 2, 1180968584, 7, 0, 0, 0, 0, 3, 3, 0),
(4, 2, 'News Item 2', 2, 1181133901, 7, 0, 0, 0, 0, 4, 4, 0),
(5, 2, '123', 2, 1181308153, 5, 0, 0, 0, 0, 5, 5, 0),
(6, 2, '123456', 2, 1181308169, 6, 0, 0, 0, 0, 6, 6, 0),
(7, 2, 'Even more and more and more news', 2, 1181313225, 6, 0, 0, 0, 0, 7, 7, 0),
(8, 2, 'NEW NEWS', 2, 1181313354, 5, 0, 0, 0, 0, 8, 8, 0),
(9, 2, 'Testing the 5 huor requierment', 2, 1183159641, 2, 0, 0, 0, 0, 9, 9, 0),
(10, 2, 'Try again', 2, 1183204091, 1, 0, 0, 0, 0, 10, 10, 0),
(11, 3, 'Community News', 2, 1187019662, 2, 0, 0, 0, 0, 11, 11, 0),
(12, 5, 'Tower Defence', 2, 1187019885, 2, 0, 0, 0, 0, 12, 12, 0),
(13, 3, 'Spring:1944', 2, 1187020178, 3, 0, 0, 0, 0, 13, 13, 0),
(14, 5, 'Spring:1944', 2, 1187020327, 2, 0, 0, 0, 0, 14, 14, 0),
(15, 4, 'How this works', 7, 1187910918, 1, 0, 0, 0, 1, 15, 15, 0),
(16, 4, '1Other things', 7, 1187911530, 12, 3, 0, 0, 0, 16, 19, 0),
(17, 4, '2Videos', 7, 1187911746, 12, 10, 0, 0, 0, 20, 30, 0),
(18, 4, '3Development', 7, 1187912137, 3, 2, 0, 0, 0, 31, 33, 0),
(19, 4, '4External utilities', 7, 1187912227, 2, 1, 0, 0, 0, 34, 35, 0),
(20, 4, '5Spring releases', 7, 1187912278, 6, 5, 0, 0, 0, 36, 41, 0),
(21, 1, 'Accounts', 10, 1188301782, 3, 0, 0, 0, 2, 42, 42, 0),
(22, 1, 'Characters support test', 5, 1188302250, 5, 1, 0, 0, 0, 43, 45, 0),
(23, 3, 'Test', 5, 1191189466, 2, 0, 0, 0, 0, 44, 44, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_topics_watch`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_topics_watch` (
  `topic_id` mediumint(8) unsigned NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  `notify_status` tinyint(1) NOT NULL,
  KEY `topic_id` (`topic_id`),
  KEY `user_id` (`user_id`),
  KEY `notify_status` (`notify_status`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_topics_watch`
-- 

INSERT INTO `phpbb_topics_watch` (`topic_id`, `user_id`, `notify_status`) VALUES 
(23, 5, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_users`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_users` (
  `user_id` mediumint(8) NOT NULL,
  `user_active` tinyint(1) default '1',
  `username` varchar(25) NOT NULL,
  `user_password` varchar(32) NOT NULL,
  `user_session_time` int(11) NOT NULL,
  `user_session_page` smallint(5) NOT NULL,
  `user_lastvisit` int(11) NOT NULL,
  `user_regdate` int(11) NOT NULL,
  `user_level` tinyint(4) default NULL,
  `user_posts` mediumint(8) unsigned NOT NULL,
  `user_timezone` decimal(5,2) NOT NULL default '0.00',
  `user_style` tinyint(4) default NULL,
  `user_lang` varchar(255) default NULL,
  `user_dateformat` varchar(14) NOT NULL default 'd M Y H:i',
  `user_new_privmsg` smallint(5) unsigned NOT NULL,
  `user_unread_privmsg` smallint(5) unsigned NOT NULL,
  `user_last_privmsg` int(11) NOT NULL,
  `user_login_tries` smallint(5) unsigned NOT NULL,
  `user_last_login_try` int(11) NOT NULL,
  `user_emailtime` int(11) default NULL,
  `user_viewemail` tinyint(1) default NULL,
  `user_attachsig` tinyint(1) default NULL,
  `user_allowhtml` tinyint(1) default '1',
  `user_allowbbcode` tinyint(1) default '1',
  `user_allowsmile` tinyint(1) default '1',
  `user_allowavatar` tinyint(1) NOT NULL default '1',
  `user_allow_pm` tinyint(1) NOT NULL default '1',
  `user_allow_viewonline` tinyint(1) NOT NULL default '1',
  `user_notify` tinyint(1) NOT NULL default '1',
  `user_notify_pm` tinyint(1) NOT NULL,
  `user_popup_pm` tinyint(1) NOT NULL,
  `user_rank` int(11) default NULL,
  `user_avatar` varchar(100) default NULL,
  `user_avatar_type` tinyint(4) NOT NULL,
  `user_email` varchar(255) default NULL,
  `user_icq` varchar(15) default NULL,
  `user_website` varchar(100) default NULL,
  `user_from` varchar(100) default NULL,
  `user_sig` text,
  `user_sig_bbcode_uid` char(10) default NULL,
  `user_aim` varchar(255) default NULL,
  `user_yim` varchar(255) default NULL,
  `user_msnm` varchar(255) default NULL,
  `user_occ` varchar(100) default NULL,
  `user_interests` varchar(255) default NULL,
  `user_actkey` varchar(32) default NULL,
  `user_newpasswd` varchar(32) default NULL,
  PRIMARY KEY  (`user_id`),
  KEY `user_session_time` (`user_session_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_users`
-- 

INSERT INTO `phpbb_users` (`user_id`, `user_active`, `username`, `user_password`, `user_session_time`, `user_session_page`, `user_lastvisit`, `user_regdate`, `user_level`, `user_posts`, `user_timezone`, `user_style`, `user_lang`, `user_dateformat`, `user_new_privmsg`, `user_unread_privmsg`, `user_last_privmsg`, `user_login_tries`, `user_last_login_try`, `user_emailtime`, `user_viewemail`, `user_attachsig`, `user_allowhtml`, `user_allowbbcode`, `user_allowsmile`, `user_allowavatar`, `user_allow_pm`, `user_allow_viewonline`, `user_notify`, `user_notify_pm`, `user_popup_pm`, `user_rank`, `user_avatar`, `user_avatar_type`, `user_email`, `user_icq`, `user_website`, `user_from`, `user_sig`, `user_sig_bbcode_uid`, `user_aim`, `user_yim`, `user_msnm`, `user_occ`, `user_interests`, `user_actkey`, `user_newpasswd`) VALUES 
(-1, 0, 'Anonymous', '', 0, 0, 0, 1180967316, 0, 0, 0.00, NULL, '', '', 0, 0, 0, 0, 0, NULL, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, NULL, '', 0, '', '', '', '', '', NULL, '', '', '', '', '', '', ''),
(2, 1, 'User1', '098f6bcd4621d373cade4e832627b4f6', 1191533989, 0, 1191425466, 1180967316, 0, 15, 0.00, 1, 'english', 'd M Y h:i a', 0, 0, 1184591395, 0, 0, NULL, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, '', 0, 'user1@springrts.org', '', '', '', '', '', '', '', '', '', '', '', ''),
(3, 0, 'User2', '098f6bcd4621d373cade4e832627b4f6', 0, 0, 0, 1187540166, 0, 0, 5.50, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, NULL, '', 0, 'user2@springrts.org', '', '', '', '', '', '', '', '', '', '', 'ae497a65d075e', NULL),
(4, 0, 'User3', '098f6bcd4621d373cade4e832627b4f6', 0, 0, 0, 1187541198, 0, 0, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'user3@springrts.org', '', '', '', '', '', '', '', '', '', '', '1d30eaf634192', NULL),
(5, 1, 'User4', '098f6bcd4621d373cade4e832627b4f6', 1191189450, 0, 1188303908, 1187541425, 0, 2, -3.50, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, NULL, '', 0, 'user4@springrts.org', '', '', '', '', '', '', '', '', '', '', '', NULL),
(6, 1, 'User5', '098f6bcd4621d373cade4e832627b4f6', 0, 0, 0, 1187541491, 0, 0, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'user5@springrts.org', '', '', '', '', '', '', '', '', '', '', '', NULL),
(7, 1, 'Administrator1', '098f6bcd4621d373cade4e832627b4f6', 1189955010, 0, 1187914913, 1187542152, 1, 27, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'admin1@springrts.org', '', '', '', '', '', '', '', '', '', '', '', NULL),
(8, 0, 'Administrator2', '098f6bcd4621d373cade4e832627b4f6', 0, 0, 0, 1187542245, 1, 0, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'admin2@springrts.org', '', '', '', '', '', '', '', '', '', '', '3ed2858ccefdc', NULL),
(9, 1, 'Moderator1', '098f6bcd4621d373cade4e832627b4f6', 1187544135, -11, 1187544070, 1187543563, 2, 0, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'mod1@springrts.org', '', '', '', '', '', '', '', '', '', '', 'b326b4096def5', NULL),
(10, 1, 'Moderator2', '098f6bcd4621d373cade4e832627b4f6', 1188301930, -1, 1187543677, 1187543621, 2, 1, 0.00, 1, 'english', 'D M d, Y g:i a', 0, 0, 0, 0, 0, NULL, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, NULL, '', 0, 'mod2@springrts.org', '', '', '', '', '', '', '', '', '', '', '', NULL);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_user_group`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_user_group` (
  `group_id` mediumint(8) NOT NULL,
  `user_id` mediumint(8) NOT NULL,
  `user_pending` tinyint(1) default NULL,
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_user_group`
-- 

INSERT INTO `phpbb_user_group` (`group_id`, `user_id`, `user_pending`) VALUES 
(1, -1, 0),
(2, 2, 0),
(3, 3, 0),
(4, 4, 0),
(5, 5, 0),
(6, 6, 0),
(2, 7, 0),
(2, 8, 0),
(9, 9, 0),
(10, 10, 0),
(11, 9, 0),
(11, 10, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_vote_desc`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_vote_desc` (
  `vote_id` mediumint(8) unsigned NOT NULL auto_increment,
  `topic_id` mediumint(8) unsigned NOT NULL,
  `vote_text` text NOT NULL,
  `vote_start` int(11) NOT NULL,
  `vote_length` int(11) NOT NULL,
  PRIMARY KEY  (`vote_id`),
  KEY `topic_id` (`topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_vote_desc`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_vote_results`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_vote_results` (
  `vote_id` mediumint(8) unsigned NOT NULL,
  `vote_option_id` tinyint(4) unsigned NOT NULL,
  `vote_option_text` varchar(255) NOT NULL,
  `vote_result` int(11) NOT NULL,
  KEY `vote_option_id` (`vote_option_id`),
  KEY `vote_id` (`vote_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_vote_results`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_vote_voters`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_vote_voters` (
  `vote_id` mediumint(8) unsigned NOT NULL,
  `vote_user_id` mediumint(8) NOT NULL,
  `vote_user_ip` char(8) NOT NULL,
  KEY `vote_id` (`vote_id`),
  KEY `vote_user_id` (`vote_user_id`),
  KEY `vote_user_ip` (`vote_user_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_vote_voters`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `phpbb_words`
-- 

CREATE TABLE IF NOT EXISTS `phpbb_words` (
  `word_id` mediumint(8) unsigned NOT NULL auto_increment,
  `word` char(100) NOT NULL,
  `replacement` char(100) NOT NULL,
  PRIMARY KEY  (`word_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `phpbb_words`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `site_language`
-- 

CREATE TABLE IF NOT EXISTS `site_language` (
  `language` varchar(15) NOT NULL,
  `native_name` varchar(50) character set utf8 collate utf8_unicode_ci default NULL,
  `id` int(11) NOT NULL auto_increment,
  `user` varchar(50) default NULL,
  `date_time` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `version_major` int(4) NOT NULL,
  `version_minor` int(4) NOT NULL,
  `header` text,
  `index` text,
  `news` text,
  `development` text,
  `download` text,
  `about` text,
  `translation` text,
  PRIMARY KEY  (`language`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `site_language`
-- 

INSERT INTO `site_language` (`language`, `native_name`, `id`, `user`, `date_time`, `version_major`, `version_minor`, `header`, `index`, `news`, `development`, `download`, `about`, `translation`) VALUES 
('Empty', 'Empty', 1, NULL, '2007-10-21 15:30:02', 1, 0, '', '', '', '', '', '', ''),
('Development', 'Development', 1, NULL, '2007-10-21 15:37:58', 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('English', 'English', 1, NULL, '2007-10-21 15:44:58', 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('Dutch', 'Nederlands', 1, NULL, '2007-10-21 15:44:58', 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('French', 'Français', 1, 'Tim Blokdijk', '2007-10-21 15:40:24', 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('German', 'Deutsch', 1, 'Tim Blokdijk', '2007-10-21 15:40:24', 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('French', NULL, 2, 'Satirik', '2007-10-21 15:30:02', 1, 0, 'news=STR%"Accueil"&END%news_tooltip=STR%"DerniÃ¨res nouvelles"&END%wiki=STR%"Wiki"&END%wiki_tooltip=STR%"Une base de connaissance faite par les utilisateurs"&END%messageboard=STR%"Forum"&END%messageboard_tooltip=STR%"La principale forme de communication du projet Spring."&END%about=STR%"A Propos"&END%about_tooltip=STR%"L\\''historique du projet et ses principaux dÃ©veloppeurs."&END%development=STR%"DÃ©veloppement"&END%development_tooltip=STR%"Informations gÃ©nÃ©rales Ã  propos du dÃ©veloppement de Spring."&END%language=STR%"Langue"&END%language_tooltip=STR%"Cliquez sur la langue de votre choix."&END%theme=STR%"ThÃ¨me"&END%theme_tooltip=STR%"SÃ©lectionnez un thÃ¨me pour ce site."&END%mission_text=STR%"Amusez vous en passant au niveau supÃ©rieur des jeux de stratÃ©gie."&END%mission_name=STR%"SPRING"&END%', NULL, NULL, NULL, NULL, NULL, NULL),
('Dutch', NULL, 2, 'Tim Blokdijk', '2007-10-21 15:43:10', 1, 0, NULL, 'download_title=STR%"Download"&END%download_text=STR%"Download Spring versie 0.74b3 van de <A HREF=\\"download\\">download pagina</A>."&END%highlight_title=STR%"Uitgelicht"&END%highlight_in_english=STR%"(in het Engels)"&END%introduction_title=STR%"Introductie"&END%introduction_text=STR%"Hallo en welkom op de pagina van het Spring project, Spring is een open source RTS spel dat uit veel verschillende \\"deel-spellen\\" bestaat waarmee je kan spelen. Je hebt om te beginnen de nieuwste Spring versie nodig wat de \\"engine\\" en een basis aan spel materiaal bevat, genoeg om mee te kunnen beginnen. Later kan je deze basis aanvullen met materiaal dat beschikbaar is op o.a. http://spring.unknown-files.com. Nieuwe spelers wordt aangeraden om de \\"Hoe te beginnen\\" uitleg te lezen hieronder.<br /><br />\r\n<br /><br />\r\nAls je wil meewerken aan de ontwikkeling van Spring dan ben je natuurlijk van harte welkom, Spring is in principe open source dus je kan op allerlei gebieden interessante dingen doen van het programmeren aan de engine, deze site vertalen, kunstmatige intelligentie, of b.v. de werelden waarin wordt gespeeld maken."&END%features_title=STR%"Spring Eigenschappen"&END%features_text=STR%"Video\\''s zijn beschikbaar als je een flash speler hebt geinstaleerd en JavaScript staat ingeschakeld."&END%features_text_flash_enabled=STR%"Klik op een eigenschap voor een korte video."&END%feature1=STR%"Grootte veldslagen."&END%feature2=STR%"Zware explosies."&END%feature3=STR%"Transformeerbaar terein."&END%feature4=STR%"Water effecten."&END%feature5=STR%"Natuurkunde."&END%feature6=STR%"Vanuit het 1ste perspectief."&END%info_title=STR%"Spring spelen"&END%info_text1=STR%"De volgende informatie kan je op weg helpen bij het spelen van spring."&END%info_text2=STR%"Deze links zijn interesant als je actief wil deelnemen aan deze gemeenschap."&END%info_getting_strated=STR%"Hoe te beginnen (instalatie) - in het Engels"&END%info_player_guide=STR%"Spel uitleg (hoe je moet spelen) - in het Engels"&END%info_news=STR%"Spring Nieuws"&END%info_messageboard=STR%"Spring Berichtenbord"&END%info_wiki=STR%"Spring Wiki"&END%info_league=STR%"Spring Toernooi"&END%screenshots_more=STR%"Meer Screenshots"&END%com_news_title=STR%"Algemeen Nieuws"&END%com_news_in_english=STR%"(in het Engels)"&END%pro_news_title=STR%"Project Nieuws"&END%pro_news_in_english=STR%"(in het Engels)"&END%', NULL, NULL, NULL, NULL, NULL),
('Development', NULL, 7, 'Tim Blokdijk', '2007-10-21 16:00:17', 1, 0, NULL, NULL, NULL, 'participate_title=STR%"Participate"&END%participate_text=STR%"Worldwide project of people that love RTS gaming, \\"Open Source\\" so everybody can join in, Code & Content development.\r\n\r\nLink to bug-tracker, feature request forum, [url=translation]translation system[/url].\r\n\r\nIÃ±tÃ«rnÃ¢tiÃ´nÃ lizÃ¦tiÃ¸n"&END%content_title=STR%"Content"&END%content_text=STR%"[u]Unit developement[/u]\r\nBuild a mod/game.\r\n[u]Mapping[/u]\r\nBuild maps and missions.\r\n[u]Writing[/u]\r\nWriters for the wiki, site and forum."&END%code_title=STR%"Code"&END%code_text=STR%"[u]Engine development[/u]\r\nC++\r\n[u]Tool development[/u]\r\nLobby, Upspring, map tools, etc.\r\n[u]Artificial Inteligence[/u]\r\nAI devlopment in C++ and Java.\r\n[u]Site development[/u]\r\nSite needs Content & Code."&END%', NULL, NULL, NULL),
('Dutch', NULL, 6, 'Tim Blokdijk', '2007-10-25 00:09:43', 1, 0, NULL, 'download_title=STR%"Download"&END%download_text=STR%"Download Spring versie 0.74b3 van de [url=download]download pagina[/url]."&END%highlight_title=STR%"Uitgelicht"&END%highlight_in_english=STR%"(in het Engels)"&END%introduction_title=STR%"Introductie"&END%introduction_text=STR%"Hallo en welkom op de pagina van het Spring project, Spring is een RTS spel dat via het \\"Open Source\\" principe wordt gebouwd. Het spel zelf bestaat uit veel verschillende \\"deel-spellen\\" waarmee je kan spelen. Je hebt om te beginnen de nieuwste Spring versie nodig wat de \\"engine\\" en een basis aan spel materiaal bevat, genoeg om mee te kunnen beginnen. Later kan je deze basis aanvullen met materiaal dat beschikbaar is op o.a. http://spring.unknown-files.com. Nieuwe spelers wordt aangeraden om de \\"Hoe te beginnen\\" uitleg te lezen hieronder.\r\n\r\nAls je wil meewerken aan de ontwikkeling van Spring dan ben je natuurlijk van harte welkom, Spring is in principe open source dus je kan op allerlei gebieden interessante dingen doen van het programmeren aan de engine, deze site vertalen, kunstmatige intelligentie, of b.v. de werelden waarin wordt gespeeld maken."&END%features_title=STR%"Spring Eigenschappen"&END%features_text=STR%"Video\\''s zijn beschikbaar als je een flash speler hebt geinstaleerd en JavaScript staat ingeschakeld."&END%features_text_flash_enabled=STR%"Klik op een eigenschap voor een korte video."&END%feature1=STR%"Grootte veldslagen."&END%feature2=STR%"Zware explosies."&END%feature3=STR%"Transformeerbaar terein."&END%feature4=STR%"Water effecten."&END%feature5=STR%"Natuurkunde."&END%feature6=STR%"Vanuit het 1ste perspectief."&END%info_title=STR%"Spring spelen"&END%info_text1=STR%"De volgende informatie kan je op weg helpen bij het spelen van spring."&END%info_text2=STR%"Deze links zijn interesant als je actief wil deelnemen aan deze gemeenschap."&END%info_getting_strated=STR%"Hoe te beginnen (instalatie) - in het Engels"&END%info_player_guide=STR%"Spel uitleg (hoe je moet spelen) - in het Engels"&END%info_news=STR%"Spring Nieuws"&END%info_messageboard=STR%"Spring Berichtenbord"&END%info_wiki=STR%"Spring Wiki"&END%info_league=STR%"Spring Toernooi"&END%screenshots_more=STR%"Meer Screenshots"&END%com_news_title=STR%"Algemeen Nieuws"&END%com_news_in_english=STR%"(in het Engels)"&END%pro_news_title=STR%"Project Nieuws"&END%pro_news_in_english=STR%"(in het Engels)"&END%screenshots_tooltip=STR%"Klik hier voor een uitvergroting."&END%', NULL, NULL, NULL, NULL, NULL),
('Development', NULL, 2, 'Tim Blokdijk', '2007-10-21 15:37:03', 1, 0, NULL, NULL, 'news_into_title=STR%"Spring news page"&END%news_into_text=STR%"This is the Spring news page, here you can find an RSS feed, all the news postings and ??.\r\nHave lots of fun and don\\''t kill anybody!\r\n\r\nStill need to make a good development text for this section."&END%com_news_title=STR%"Community News"&END%com_news_in_english=STR%"(in English)"&END%pro_news_title=STR%"Project News"&END%pro_news_in_english=STR%"(in English)"&END%', NULL, NULL, NULL, NULL),
('English', NULL, 2, 'Tim Blokdijk', '2007-10-21 15:44:06', 1, 0, NULL, NULL, 'news_intro_title=STR%"Spring news page"&END%news_intro_text=STR%"This is the Spring news page, here you can find an RSS feed, all the news postings and ??.\r\n\r\nHave lots of fun and don\\''t kill anybody!\r\n\r\nCommunity News is freely editable by anybody with a messageboard account.\r\nProject News is only editable by Spring developers and has the more \\"official\\" news."&END%com_news_title=STR%"Community News"&END%com_news_in_english=STR%"TODO: Make dynamic"&END%pro_news_title=STR%"Project News"&END%pro_news_in_english=STR%"TODO: Make dynamic"&END%', NULL, NULL, NULL, NULL),
('Development', NULL, 3, 'Tim Blokdijk', '2007-10-21 15:36:49', 1, 0, NULL, NULL, NULL, NULL, NULL, 'project_description_title=STR%"The Spring Project"&END%project_description_text=STR%"Spring is an Open source ... LOADS of text here about Spring, the way it\\''s set-up, history, Total Annihilation, bla, bla, ect. ect.\r\n\r\nThe roots of the project lie with the &quot;Total Annihilation&quot;&trade; gaming community which is around 10 years old. The Spring project itself strated in 2004 with its code released under the GPL, \r\n\r\nContent\r\nCode\r\nAdmins\r\nRetired contributors\r\n\r\nAll the people that maintain this great athmosphere within our communety."&END%history_title=STR%""&END%history_text=STR%""&END%developers_title=STR%"Spring Developers"&END%developers_in_english=STR%"(in English)"&END%', NULL),
('English', NULL, 3, 'Tim Blokdijk', '2007-10-21 15:44:06', 1, 0, NULL, NULL, NULL, NULL, NULL, 'project_description_title=STR%"About the Spring Project"&END%project_description_text=STR%"Spring is an Open source ... LOADS of text here about Spring, the way it\\''s set-up, history, Total Annihilation, bla, bla, ect. ect.\r\n\r\nThe roots of the project lie with the &quot;Total Annihilation&quot;&trade; gaming community which is around 10 years old. The Spring project itself strated in 2004 with its code released under the GPL,\r\n\r\nContent\r\nCode\r\nAdmins\r\nRetired contributors\r\n\r\nAll the people that maintain this great athmosphere within our communety."&END%history_title=STR%""&END%history_text=STR%""&END%developers_title=STR%"Spring Developers"&END%developers_in_english=STR%""&END%', NULL),
('Development', NULL, 4, 'Tim Blokdijk', '2007-10-21 15:36:37', 1, 0, NULL, NULL, NULL, 'participate_title=STR%"Participate"&END%participate_text=STR%"Worldwide project of people that love RTS gaming, \\"Open Source\\" so everybody can join in, Code & Content development.\r\n\r\nLink to bug-tracker, feature request forum, [url=translation]translation system[/url].\r\n\r\nIÃ±tÃ«rnÃ¢tiÃ´nÃ lizÃ¦tiÃ¸n"&END%content_title=STR%"Content"&END%content_text=STR%"[u]Unit developement[/u]\r\nBuild a mod/game.\r\n[u]Mapping[/u]\r\nBuild maps and missions.\r\n[u]Writing[/u]\r\nWriters for the wiki, site and forum."&END%code_title=STR%"Code"&END%code_text=STR%"[u]Engine development[/u]\r\nC++\r\n[u]Tool development[/u]\r\nLobby, Upspring, map tools, etc.\r\n[u]Artificial Inteligence[/u]\r\nAI devlopment in C++ and Java.\r\n[u]Site development[/u]\r\nSite needs Content & Code."&END%', NULL, NULL, NULL),
('German', NULL, 2, 'Tim Blokdijk', '2007-10-21 15:40:42', 1, 0, 'news=STR%"News"&END%news_tooltip=STR%"Vier Tote, brennende HÃ¤user und Ãœberschwemmungen"&END%wiki=STR%"Wiki"&END%wiki_tooltip=STR%"Unser Wiki"&END%messageboard=STR%"Berichteboard"&END%messageboard_tooltip=STR%"Unser webforum"&END%about=STR%"Ãœber ons"&END%about_tooltip=STR%"Wir mÃ¶gen prahlen"&END%development=STR%"Entwicklung"&END%development_tooltip=STR%"Allgemeine Entwicklungsinformationen"&END%language=STR%"Sprache"&END%language_tooltip=STR%"WÃ¤hlen Sie eine Sprache"&END%theme=STR%"Thema"&END%theme_tooltip=STR%"WÃ¤hlen Sie ein Thema aus"&END%mission_text=STR%"GenieÃŸen Sie nehmend <ACRONYM TITLE=\\"Real Time Strategy\\">RTS</ACRONYM> Gaming zur hÃ¶chsten Ebene."&END%mission_name=STR%"SPRING"&END%', NULL, NULL, NULL, NULL, NULL, NULL),
('English', NULL, 4, 'Tim Blokdijk', '2007-10-21 15:44:06', 1, 0, NULL, NULL, NULL, 'participate_title=STR%"Participate"&END%participate_text=STR%"We are a buch of people from around the world - love RTS gaming - we develop Spring because we like to - we do this mostly on an \\"Open Source\\" basis so everybody can help develop the code and content that we collectivly play. - The developemnt process is split in code and content development both are heavely interlinked so the distinction is not that hard, the main diffrence is that you need other tools and skills.\r\n\r\nBug tracker, feature request sub-forum ect.\r\n\r\nTry the translation system [url=translation]here[/url].\r\n[b]Bold[/b]\r\n[i]Italics[/i]\r\n[u]Under-line[/u]\r\n// Also see how \\\\\\\\ Slashes are used.\r\n<HTML> and other <SCRIPT>tags<\\\\SCRIPT> like <IMG SRC=\\"picture.png\\">, <OBJECT> and <EMBED>.\r\nAll sorts of `\\"\\''Â¨Â´\\'' quotes.\r\nChina:\r\næ‘˜ã€€è¦ï¼šåœ¨åˆ†æžä¿¡ç”¨è¯„ä¼°é‡è¦æ€§å’Œä¿¡ç”¨è¯„ä¼°å›½å†…å¤–çŽ°çŠ¶çš„åŸºç¡€ä¸Š,æå‡ºäº†ç”¨äºŽä¼ä¸šä¿¡ç”¨è¯„ä¼°çš„æŒ‡ï¿½ ï¿½ä½“ç³»,ç»™å‡ºäº†æŒ‡ï¿½ ï¿½ä½“ç³»ä¸­ç¦»æ•£æ•°æ®çš„é‡åŒ–æ–¹æ³•å’ŒæŒ‡ï¿½ ï¿½æ•°æ®çš„å½’ä¸€å¤„ç†æ–¹æ³•.ï¿½ ï¿½æ®è¿™ä¸€æŒ‡ï¿½ ï¿½ä½“ç³»å»ºç«‹äº†åŸºäºŽBPç¥žç»ç½‘ç»œçš„ä¼ä¸šä¿¡ç”¨3å±‚ç¥žç»ç½‘ç»œè¯„ä¼°æ¨¡åž‹.è¯¥æ¨¡åž‹é€šè¿‡ç»™å®šçš„æ•™å¸ˆæ•°æ®è®­ç»ƒåŽ,å…·æœ‰äº†å¯¹ä¼ä¸šä¿¡ç”¨çš„é¢„æµ‹åŠŸèƒ½.å®žéªŒç»“æžœè¯æ˜Ž,è¯¥æ¨¡åž‹ç”¨äºŽä¼ä¸šä¿¡ç”¨è¯„ä¼°,å‡å°‘äº†ä¼ä¸šä¿¡ç”¨è¯„ä¼°ï¿½ ç»Ÿçš„å®šæ€§æ–¹æ³•ä¸­æƒé‡ç¡®å®šçš„äººä¸ºï¿½ ï¿½ ,è¯„ä¼°æ­£ç¡®çŽ‡è¾¾åˆ°\r\nJapan:\r\nãƒ—ãƒ­ãƒ¢ãƒ“ãƒ‡ã‚ªã‚’ä¸­å¿ƒã«äººæ°—å‹•ç”»ã‚’æŽ¢ã›ã‚‹ã‚µã‚¤ãƒˆ\r\nTaiwan:\r\nä¸­å›½ç”µè§†æ¸¸æˆç¬¬ä¸€é—¨æˆ·-ç”µçŽ©å·´å£«-ç”µè§†æ¸¸æˆ|ç”µå­æ¸¸æˆ\r\nKorea:\r\në°‘ì— ìƒ¤ì˜¤ë‹˜ê»˜ì„œ ï¿½ ï¿½ìš©ì´ ì•ˆëœë‹¤ï¿½  í•˜ì‹œê¸°ì— ë‹¤ë¥¸ ë¶„ë“¤ê»˜ë„ í˜¹ ï¿½ ï¿½ ê²½í—˜ì´ ë„ì›€ï¿½ ê¹Œ ì‹¶ì–´ ê´œížˆ ê¸¸ê²Œ ë„ï¿½ ï¿½ì—¬ ë´…ë‹ˆë‹¤.\r\nArabic:\r\nÙˆÙŠÙƒÙŠØ¨ÙŠØ¯ÙŠØ§ Ù…Ø´Ø±ÙˆØ¹ Ù…ØªØ¹Ø¯Ø¯ Ø§Ù„Ù„ØºØ§Øª ÙÙŠ Ø£ÙƒØ«Ø± Ù…Ù† 250 Ù„ØºØ© Ù„ØµÙ†Ø¹ Ù…ÙˆØ³ÙˆØ¹Ø© Ø¯Ù‚ÙŠÙ‚Ø© ÙˆÙ…ØªÙƒØ§Ù…Ù„Ø© ÙˆÙ…ØªÙ†ÙˆØ¹Ø© ÙˆÙ…ÙØªÙˆØ­Ø© ÙˆÙ…Ø­Ø§ÙŠØ¯Ø© ÙˆÙ…Ø¬Ø§Ù†ÙŠØ© Ù„Ù„Ø¬Ù…ÙŠØ¹ØŒ ÙŠØ³ØªØ·ÙŠØ¹ Ø§Ù„Ø¬Ù…ÙŠØ¹ Ø§Ù„Ù…Ø³Ø§Ù‡Ù…Ø© ÙÙŠ ØªØ­Ø±ÙŠØ±Ù‡Ø§. Ø¨Ø¯Ø£Øª Ø§Ù„Ù†Ø³Ø®Ø© Ø§Ù„Ø¹Ø±Ø¨ÙŠØ© ÙÙŠ Ø³Ø¨ØªÙ…Ø¨Ø±\r\nHebrew:\r\n×¢×œ×™×œ×•×ª ×‘×¢×œ ×•×¢ï¿½ ×ª ×”×•× ××¤×•×¡ ×ž×™×ª×•×œ×•×’×™ ×§×“×•×, ×”×ž×¡×¤×¨ ××ª ×¡×™×¤×•×¨× ×©×œ ××œ×™ ×›ï¿½ ×¢×Ÿ ×•××•×’×¨×™×ª, ×•ï¿½ ×—×©×‘ ×œ×ž×™×ª×•×¡\r\nSwidish:\r\nÃ¥Ã¶Ã¤\r\nDutch:\r\nÃ©Ã¨Ã«\r\n\r\nIÃ±tÃ«rnÃ¢tiÃ´nÃ lizÃ¦tiÃ¸n"&END%content_title=STR%"Content"&END%content_text=STR%"[u]Unit developement[/u]\r\nWork on the units you can build and command, you need modeling, animation, texturing and scripting skills to make fully functional units.\r\n\r\n[u]Mapping[/u]\r\nMapping is making the worlds where battles can be fought, it\\''s also possible to make missions.\r\n[u]Writing[/u]\r\nWe need documentation, story-lines, reviews, translations for this site and just generaly nice people to build our communety on."&END%code_title=STR%"Code"&END%code_text=STR%"[u]Engine development[/u]\r\nThe Spring engine is the main dish and it needs a lot of work, if you know C++ take a look at it.\r\n\r\n[u]Tool development[/u]\r\nLobby and others. We have a few app\\''s that are used for unit and map developement and also these need work.\r\n\r\n[u]Artificial Inteligence[/u]\r\nGeneraly we can still beat the AI\\''s..\r\n\r\n[u]Site development[/u]\r\nLike to code up some new features for this site? Have you found a bug in it? The code is availeble."&END%', NULL, NULL, NULL),
('Development', NULL, 5, 'Tim Blokdijk', '2007-10-21 15:36:24', 1, 0, 'news=STR%"News"&END%news_tooltip=STR%"Tooltip for link to news page"&END%wiki=STR%"Wiki"&END%wiki_tooltip=STR%"Tooltip for link to wiki"&END%messageboard=STR%"Messageboard"&END%messageboard_tooltip=STR%"Tooltip for link to messageboard"&END%about=STR%"About us"&END%about_tooltip=STR%"Tooltip for link to about"&END%development=STR%"Development"&END%development_tooltip=STR%"Tooltip for link to development page"&END%language=STR%"Language"&END%language_tooltip=STR%"Tooltip for language button when JavaScript is disabled."&END%theme=STR%"Theme"&END%theme_tooltip=STR%"Tooltip for theme button when JavaScript is disabled."&END%mission_text=STR%"Enjoy taking <ACRONYM TITLE=\\"Real Time Strategy\\">RTS</ACRONYM> gaming to the highest level."&END%mission_name=STR%"SPRING"&END%language_tooltip_open=STR%"Click to open the language selection menu."&END%language_tooltip_close=STR%"Click on a language or click here to close the language selection menu."&END%', NULL, NULL, NULL, NULL, NULL, NULL),
('English', NULL, 5, 'Tim Blokdijk', '2007-10-21 15:44:06', 1, 0, 'news=STR%"News"&END%news_tooltip=STR%"Spring\\''s news page."&END%wiki=STR%"Wiki"&END%wiki_tooltip=STR%"A world of user contributed Spring knowledge."&END%messageboard=STR%"Messageboard"&END%messageboard_tooltip=STR%"The main form of communication for the Spring project."&END%about=STR%"About us"&END%about_tooltip=STR%"The project background and its core developers."&END%development=STR%"Development"&END%development_tooltip=STR%"General information about Spring\\''s development."&END%language=STR%"Language"&END%language_tooltip=STR%"Click on the language of your choice."&END%theme=STR%"Theme"&END%theme_tooltip=STR%"Select a theme for this site."&END%mission_text=STR%"Enjoy taking Real Time Strategy gaming to a higher level."&END%mission_name=STR%"SPRING"&END%language_tooltip_open=STR%"Click to open the language selection menu."&END%language_tooltip_close=STR%"Click on a language or click here to close the language selection menu."&END%', NULL, NULL, NULL, NULL, NULL, NULL),
('Development', NULL, 6, 'Tim Blokdijk', '2007-10-21 15:36:15', 1, 0, NULL, 'download_title=STR%"Download"&END%download_text=STR%"<A HREF=\\"download\\">Link to downlaod page</A> version information, date of release and possibly a codename."&END%highlight_title=STR%"Highlight"&END%highlight_in_english=STR%"(in English) used for non-english translations to make clear that this section is not translated."&END%introduction_title=STR%"Introduction"&END%introduction_text=STR%"What is Spring? FILLER --- Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas nonummy urna sit amet erat. Vivamus ut tortor at orci venenatis volutpat. Nulla facilisi. Cras eget mauris. Cras faucibus. Quisque scelerisque, purus sit amet pulvinar laoreet, ante dui venenatis mauris, id eleifend nibh turpis at lectus. Integer varius. Nulla facilisi. Donec vestibulum. Duis arcu diam, bibendum quis, sodales eu, fringilla laoreet, augue. Ut nec turpis. Ut tristique ante et felis. Quisque libero mi, ultricies sit amet, blandit vitae, eleifend sit amet, ligula. Mauris ac velit ac neque dictum euismod. Sed quam. Sed massa massa, vestibulum non, faucibus eu, rutrum a, lacus. Integer in ligula. Nam sit amet libero eget enim dignissim iaculis. Mauris nunc sem, pulvinar eu, faucibus et, auctor at, tortor. Nulla dapibus dolor sed lorem. --- FILLER"&END%features_title=STR%"Spring Features"&END%features_text=STR%"Feature text for non-javascript/non-flash browsers."&END%features_text_flash_enabled=STR%"Feature text for javascript enabled and flash installed browsers."&END%feature1=STR%"Feature 1 description"&END%feature2=STR%"Feature 2 description"&END%feature3=STR%"Feature 3 description"&END%feature4=STR%"Feature 4 description"&END%feature5=STR%"Feature 5 description"&END%feature6=STR%"Feature 6 description"&END%info_title=STR%"Playing Spring"&END%info_text1=STR%"Text for the more basic information links."&END%info_text2=STR%"Text for the more involved players."&END%info_getting_strated=STR%"Getting Started (installation) (in english)"&END%info_player_guide=STR%"Player Guide (how to play) (in english)"&END%info_news=STR%"Spring News"&END%info_messageboard=STR%"Spring Messageboard"&END%info_wiki=STR%"Spring Wiki"&END%info_league=STR%"Spring Leage"&END%screenshots_more=STR%"More Screenshots..."&END%com_news_title=STR%"Community News"&END%com_news_in_english=STR%"(in English)"&END%pro_news_title=STR%"Project News"&END%pro_news_in_english=STR%"(in English)"&END%screenshots_tooltip=STR%"Spring Screenshot - Click for a larger version"&END%', NULL, NULL, NULL, NULL, NULL),
('English', NULL, 6, 'Tim Blokdijk', '2007-10-21 15:44:06', 1, 0, NULL, 'download_title=STR%"Download"&END%download_text=STR%"Get Spring version 0.74b3 from the [url=download]download page[/url]."&END%highlight_title=STR%"Highlight"&END%highlight_in_english=STR%"TODO: Make dynamic"&END%introduction_title=STR%"Introduction of the Game"&END%introduction_text=STR%"Hello and welcome to the world of Spring gaming. Spring is a open source RTS engine that features many different game universes to fight in. You need the latest Spring release which contains the core engine components and some content to play with. Later you can check out the many other universes that are available from [url]http://spring.unknown-files.com[/url]. As a new player you should read the getting started guide below.\r\n\r\nIf you would like to involve yourself in the ongoing development process (code and/or content) then click on the development link in the menu. With spring you can work on the engine code iteself, the tools, this site, artificial intelligence, or the universes in which people play."&END%features_title=STR%"Spring Features"&END%features_text=STR%"Video\\''s are availeble if you have a flash player installed and JavaScript enabled."&END%features_text_flash_enabled=STR%"Click on a feature below for a short flash video."&END%feature1=STR%"Massive battles."&END%feature2=STR%"Cool explosions."&END%feature3=STR%"Deformable terain."&END%feature4=STR%"Water effects."&END%feature5=STR%"Phisics."&END%feature6=STR%"1st person control."&END%info_title=STR%"Playing Spring"&END%info_text1=STR%"The following information can help you on your way as a Spring player."&END%info_text2=STR%"Check out the following links if you like to be active in the community."&END%info_getting_strated=STR%"Getting Started (installation)"&END%info_player_guide=STR%"Player Guide (how to play)"&END%info_news=STR%"Spring News"&END%info_messageboard=STR%"Spring Messageboard"&END%info_wiki=STR%"Spring Wiki"&END%info_league=STR%"Spring League"&END%screenshots_more=STR%"More Screenshots"&END%com_news_title=STR%"Community News"&END%com_news_in_english=STR%"TODO: Make dynamic"&END%pro_news_title=STR%"Project News"&END%pro_news_in_english=STR%"TODO: Make dynamic"&END%screenshots_tooltip=STR%"Spring Screenshot - Click for a larger version"&END%', NULL, NULL, NULL, NULL, NULL),
('Dutch', NULL, 3, 'Tim Blokdijk', '2007-10-21 15:43:10', 1, 0, 'news=STR%"Nieuws"&END%news_tooltip=STR%"De nieuws pagina."&END%wiki=STR%"Wiki"&END%wiki_tooltip=STR%"De wiki met een wereld aan Spring informatie."&END%messageboard=STR%"Berichtenbord"&END%messageboard_tooltip=STR%"De voornaamste manier van communiceren voor dit project."&END%about=STR%"Over ons"&END%about_tooltip=STR%"De mensen achter en de historie van dit project."&END%development=STR%"Ontwikkeling"&END%development_tooltip=STR%"Meer informatie over meehelpen aan de ontwikkeling van Spring."&END%language=STR%"Talen"&END%language_tooltip=STR%"Selecteer een taal naar keuze."&END%theme=STR%"Thema"&END%theme_tooltip=STR%"Kies een ander thema."&END%mission_text=STR%"Geniet van Real Time Strategy gaming naar een hoger niveau te tillen."&END%mission_name=STR%"SPRING"&END%language_tooltip_open=STR%"Klik hier om het talen menu te openen."&END%language_tooltip_close=STR%"Klik hier om het talen menu te sluiten."&END%', NULL, NULL, NULL, NULL, NULL, NULL),
('Dutch', NULL, 7, 'Tim Blokdijk', '2007-10-25 12:30:45', 1, 0, NULL, NULL, 'news_into_title=STR%"Spring nieuws pagina"&END%news_into_text=STR%"Op deze pagina lees je het laatste Spring news, omdat Spring een internationaal project is is het nieuws geschreven in het Engels."&END%com_news_title=STR%"Algemeen Nieuws"&END%com_news_in_english=STR%"(in het Engels)"&END%pro_news_title=STR%"Project Nieuws"&END%pro_news_in_english=STR%"(in het Engels)"&END%', NULL, NULL, NULL, NULL),
('Dutch', NULL, 8, 'Tim Blokdijk', '2007-10-25 12:33:39', 1, 0, NULL, NULL, NULL, 'participate_title=STR%"Meedoen"&END%participate_text=STR%"Iñtërnâtiônàlizætiøn"&END%content_title=STR%"Inhoud"&END%content_text=STR%""&END%code_title=STR%"Code"&END%code_text=STR%""&END%', NULL, NULL, NULL);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_archive`
-- 

CREATE TABLE IF NOT EXISTS `wiki_archive` (
  `ar_namespace` int(11) NOT NULL default '0',
  `ar_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `ar_text` mediumblob NOT NULL,
  `ar_comment` tinyblob NOT NULL,
  `ar_user` int(5) unsigned NOT NULL default '0',
  `ar_user_text` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `ar_timestamp` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `ar_minor_edit` tinyint(1) NOT NULL default '0',
  `ar_flags` tinyblob NOT NULL,
  `ar_rev_id` int(8) unsigned default NULL,
  `ar_text_id` int(8) unsigned default NULL,
  `ar_deleted` tinyint(1) unsigned NOT NULL default '0',
  `ar_len` int(8) unsigned default NULL,
  KEY `name_title_timestamp` (`ar_namespace`,`ar_title`,`ar_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_archive`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_categorylinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_categorylinks` (
  `cl_from` int(8) unsigned NOT NULL default '0',
  `cl_to` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `cl_sortkey` varchar(86) character set utf8 collate utf8_bin NOT NULL default '',
  `cl_timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  UNIQUE KEY `cl_from` (`cl_from`,`cl_to`),
  KEY `cl_sortkey` (`cl_to`,`cl_sortkey`),
  KEY `cl_timestamp` (`cl_to`,`cl_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_categorylinks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_externallinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_externallinks` (
  `el_from` int(8) unsigned NOT NULL default '0',
  `el_to` blob NOT NULL,
  `el_index` blob NOT NULL,
  KEY `el_from` (`el_from`,`el_to`(40)),
  KEY `el_to` (`el_to`(60),`el_from`),
  KEY `el_index` (`el_index`(60))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_externallinks`
-- 

INSERT INTO `wiki_externallinks` (`el_from`, `el_to`, `el_index`) VALUES 
(3, 0x687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f77696b692f4c696e7578, 0x687474703a2f2f636f6d2e636c616e2d73792e7461737072696e672e2f77696b692f4c696e7578),
(3, 0x687474703a2f2f7777772e6d6963726f736f66742e636f6d2f77696e646f77732f646972656374782f64656661756c742e617370783f75726c3d2f77696e646f77732f646972656374782f646f776e6c6f6164732f64656661756c742e68746d, 0x687474703a2f2f636f6d2e6d6963726f736f66742e7777772e2f77696e646f77732f646972656374782f64656661756c742e617370783f75726c3d2f77696e646f77732f646972656374782f646f776e6c6f6164732f64656661756c742e68746d),
(3, 0x687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f646f776e6c6f61642e706870, 0x687474703a2f2f636f6d2e636c616e2d73792e7461737072696e672e2f646f776e6c6f61642e706870),
(3, 0x687474703a2f2f7777772e706f7274666f72776172642e636f6d2f726f75746572732e68746d, 0x687474703a2f2f636f6d2e706f7274666f72776172642e7777772e2f726f75746572732e68746d),
(3, 0x687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f77696b692f47657474696e675f53746172746564, 0x687474703a2f2f636f6d2e636c616e2d73792e7461737072696e672e2f77696b692f47657474696e675f53746172746564),
(1, 0x687474703a2f2f6d6574612e77696b696d656469612e6f72672f77696b692f48656c703a436f6e74656e7473, 0x687474703a2f2f6f72672e77696b696d656469612e6d6574612e2f77696b692f48656c703a436f6e74656e7473),
(1, 0x687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a436f6e66696775726174696f6e5f73657474696e6773, 0x687474703a2f2f6f72672e6d6564696177696b692e7777772e2f77696b692f48656c703a436f6e66696775726174696f6e5f73657474696e6773),
(1, 0x687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a464151, 0x687474703a2f2f6f72672e6d6564696177696b692e7777772e2f77696b692f48656c703a464151),
(1, 0x687474703a2f2f6d61696c2e77696b696d656469612e6f72672f6d61696c6d616e2f6c697374696e666f2f6d6564696177696b692d616e6e6f756e6365, 0x687474703a2f2f6f72672e77696b696d656469612e6d61696c2e2f6d61696c6d616e2f6c697374696e666f2f6d6564696177696b692d616e6e6f756e6365);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_filearchive`
-- 

CREATE TABLE IF NOT EXISTS `wiki_filearchive` (
  `fa_id` int(11) NOT NULL auto_increment,
  `fa_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `fa_archive_name` varchar(255) character set utf8 collate utf8_bin default '',
  `fa_storage_group` varchar(16) default NULL,
  `fa_storage_key` varchar(64) character set utf8 collate utf8_bin default '',
  `fa_deleted_user` int(11) default NULL,
  `fa_deleted_timestamp` char(14) character set utf8 collate utf8_bin default '',
  `fa_deleted_reason` text,
  `fa_size` int(8) unsigned default '0',
  `fa_width` int(5) default '0',
  `fa_height` int(5) default '0',
  `fa_metadata` mediumblob,
  `fa_bits` int(3) default '0',
  `fa_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE') default NULL,
  `fa_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart') default 'unknown',
  `fa_minor_mime` varchar(32) default 'unknown',
  `fa_description` tinyblob,
  `fa_user` int(5) unsigned default '0',
  `fa_user_text` varchar(255) character set utf8 collate utf8_bin default NULL,
  `fa_timestamp` char(14) character set utf8 collate utf8_bin default '',
  `fa_deleted` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`fa_id`),
  KEY `fa_name` (`fa_name`,`fa_timestamp`),
  KEY `fa_storage_group` (`fa_storage_group`,`fa_storage_key`),
  KEY `fa_deleted_timestamp` (`fa_deleted_timestamp`),
  KEY `fa_deleted_user` (`fa_deleted_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_filearchive`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_hitcounter`
-- 

CREATE TABLE IF NOT EXISTS `wiki_hitcounter` (
  `hc_id` int(10) unsigned NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1 MAX_ROWS=25000;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_hitcounter`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_image`
-- 

CREATE TABLE IF NOT EXISTS `wiki_image` (
  `img_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `img_size` int(8) unsigned NOT NULL default '0',
  `img_width` int(5) NOT NULL default '0',
  `img_height` int(5) NOT NULL default '0',
  `img_metadata` mediumblob NOT NULL,
  `img_bits` int(3) NOT NULL default '0',
  `img_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE') default NULL,
  `img_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart') NOT NULL default 'unknown',
  `img_minor_mime` varchar(32) NOT NULL default 'unknown',
  `img_description` tinyblob NOT NULL,
  `img_user` int(5) unsigned NOT NULL default '0',
  `img_user_text` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `img_timestamp` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  PRIMARY KEY  (`img_name`),
  KEY `img_size` (`img_size`),
  KEY `img_timestamp` (`img_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_image`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_imagelinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_imagelinks` (
  `il_from` int(8) unsigned NOT NULL default '0',
  `il_to` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  UNIQUE KEY `il_from` (`il_from`,`il_to`),
  KEY `il_to` (`il_to`,`il_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_imagelinks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_interwiki`
-- 

CREATE TABLE IF NOT EXISTS `wiki_interwiki` (
  `iw_prefix` char(32) NOT NULL,
  `iw_url` char(127) NOT NULL,
  `iw_local` tinyint(1) NOT NULL,
  `iw_trans` tinyint(1) NOT NULL default '0',
  UNIQUE KEY `iw_prefix` (`iw_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_interwiki`
-- 

INSERT INTO `wiki_interwiki` (`iw_prefix`, `iw_url`, `iw_local`, `iw_trans`) VALUES 
('abbenormal', 'http://www.ourpla.net/cgi-bin/pikie.cgi?$1', 0, 0),
('acadwiki', 'http://xarch.tu-graz.ac.at/autocad/wiki/$1', 0, 0),
('acronym', 'http://www.acronymfinder.com/af-query.asp?String=exact&Acronym=$1', 0, 0),
('advogato', 'http://www.advogato.org/$1', 0, 0),
('aiwiki', 'http://www.ifi.unizh.ch/ailab/aiwiki/aiw.cgi?$1', 0, 0),
('alife', 'http://news.alife.org/wiki/index.php?$1', 0, 0),
('annotation', 'http://bayle.stanford.edu/crit/nph-med.cgi/$1', 0, 0),
('annotationwiki', 'http://www.seedwiki.com/page.cfm?wikiid=368&doc=$1', 0, 0),
('arxiv', 'http://www.arxiv.org/abs/$1', 0, 0),
('aspienetwiki', 'http://aspie.mela.de/Wiki/index.php?title=$1', 0, 0),
('bemi', 'http://bemi.free.fr/vikio/index.php?$1', 0, 0),
('benefitswiki', 'http://www.benefitslink.com/cgi-bin/wiki.cgi?$1', 0, 0),
('brasilwiki', 'http://rio.ifi.unizh.ch/brasilienwiki/index.php/$1', 0, 0),
('bridgeswiki', 'http://c2.com/w2/bridges/$1', 0, 0),
('c2find', 'http://c2.com/cgi/wiki?FindPage&value=$1', 0, 0),
('cache', 'http://www.google.com/search?q=cache:$1', 0, 0),
('ciscavate', 'http://ciscavate.org/index.php/$1', 0, 0),
('cliki', 'http://ww.telent.net/cliki/$1', 0, 0),
('cmwiki', 'http://www.ourpla.net/cgi-bin/wiki.pl?$1', 0, 0),
('codersbase', 'http://www.codersbase.com/$1', 0, 0),
('commons', 'http://commons.wikimedia.org/wiki/$1', 0, 0),
('consciousness', 'http://teadvus.inspiral.org/', 0, 0),
('corpknowpedia', 'http://corpknowpedia.org/wiki/index.php/$1', 0, 0),
('creationmatters', 'http://www.ourpla.net/cgi-bin/wiki.pl?$1', 0, 0),
('dejanews', 'http://www.deja.com/=dnc/getdoc.xp?AN=$1', 0, 0),
('demokraatia', 'http://wiki.demokraatia.ee/', 0, 0),
('dictionary', 'http://www.dict.org/bin/Dict?Database=*&Form=Dict1&Strategy=*&Query=$1', 0, 0),
('disinfopedia', 'http://www.disinfopedia.org/wiki.phtml?title=$1', 0, 0),
('diveintoosx', 'http://diveintoosx.org/$1', 0, 0),
('docbook', 'http://docbook.org/wiki/moin.cgi/$1', 0, 0),
('dolphinwiki', 'http://www.object-arts.com/wiki/html/Dolphin/$1', 0, 0),
('drumcorpswiki', 'http://www.drumcorpswiki.com/index.php/$1', 0, 0),
('dwjwiki', 'http://www.suberic.net/cgi-bin/dwj/wiki.cgi?$1', 0, 0),
('eĉei', 'http://www.ikso.net/cgi-bin/wiki.pl?$1', 0, 0),
('echei', 'http://www.ikso.net/cgi-bin/wiki.pl?$1', 0, 0),
('ecxei', 'http://www.ikso.net/cgi-bin/wiki.pl?$1', 0, 0),
('efnetceewiki', 'http://purl.net/wiki/c/$1', 0, 0),
('efnetcppwiki', 'http://purl.net/wiki/cpp/$1', 0, 0),
('efnetpythonwiki', 'http://purl.net/wiki/python/$1', 0, 0),
('efnetxmlwiki', 'http://purl.net/wiki/xml/$1', 0, 0),
('elibre', 'http://enciclopedia.us.es/index.php/$1', 0, 0),
('eljwiki', 'http://elj.sourceforge.net/phpwiki/index.php/$1', 0, 0),
('emacswiki', 'http://www.emacswiki.org/cgi-bin/wiki.pl?$1', 0, 0),
('eokulturcentro', 'http://esperanto.toulouse.free.fr/wakka.php?wiki=$1', 0, 0),
('evowiki', 'http://www.evowiki.org/index.php/$1', 0, 0),
('finalempire', 'http://final-empire.sourceforge.net/cgi-bin/wiki.pl?$1', 0, 0),
('firstwiki', 'http://firstwiki.org/index.php/$1', 0, 0),
('foldoc', 'http://www.foldoc.org/foldoc/foldoc.cgi?$1', 0, 0),
('foxwiki', 'http://fox.wikis.com/wc.dll?Wiki~$1', 0, 0),
('fr.be', 'http://fr.wikinations.be/$1', 0, 0),
('fr.ca', 'http://fr.ca.wikinations.org/$1', 0, 0),
('fr.fr', 'http://fr.fr.wikinations.org/$1', 0, 0),
('fr.org', 'http://fr.wikinations.org/$1', 0, 0),
('freebsdman', 'http://www.FreeBSD.org/cgi/man.cgi?apropos=1&query=$1', 0, 0),
('gamewiki', 'http://gamewiki.org/wiki/index.php/$1', 0, 0),
('gej', 'http://www.esperanto.de/cgi-bin/aktivikio/wiki.pl?$1', 0, 0),
('gentoo-wiki', 'http://gentoo-wiki.com/$1', 0, 0),
('globalvoices', 'http://cyber.law.harvard.edu/dyn/globalvoices/wiki/$1', 0, 0),
('gmailwiki', 'http://www.gmailwiki.com/index.php/$1', 0, 0),
('google', 'http://www.google.com/search?q=$1', 0, 0),
('googlegroups', 'http://groups.google.com/groups?q=$1', 0, 0),
('gotamac', 'http://www.got-a-mac.org/$1', 0, 0),
('greencheese', 'http://www.greencheese.org/$1', 0, 0),
('hammondwiki', 'http://www.dairiki.org/HammondWiki/index.php3?$1', 0, 0),
('haribeau', 'http://wiki.haribeau.de/cgi-bin/wiki.pl?$1', 0, 0),
('herzkinderwiki', 'http://www.herzkinderinfo.de/Mediawiki/index.php/$1', 0, 0),
('hewikisource', 'http://he.wikisource.org/wiki/$1', 1, 0),
('hrwiki', 'http://www.hrwiki.org/index.php/$1', 0, 0),
('iawiki', 'http://www.IAwiki.net/$1', 0, 0),
('imdb', 'http://us.imdb.com/Title?$1', 0, 0),
('infosecpedia', 'http://www.infosecpedia.org/pedia/index.php/$1', 0, 0),
('jargonfile', 'http://sunir.org/apps/meta.pl?wiki=JargonFile&redirect=$1', 0, 0),
('jefo', 'http://www.esperanto-jeunes.org/vikio/index.php?$1', 0, 0),
('jiniwiki', 'http://www.cdegroot.com/cgi-bin/jini?$1', 0, 0),
('jspwiki', 'http://www.ecyrd.com/JSPWiki/Wiki.jsp?page=$1', 0, 0),
('kerimwiki', 'http://wiki.oxus.net/$1', 0, 0),
('kmwiki', 'http://www.voght.com/cgi-bin/pywiki?$1', 0, 0),
('knowhow', 'http://www2.iro.umontreal.ca/~paquetse/cgi-bin/wiki.cgi?$1', 0, 0),
('lanifexwiki', 'http://opt.lanifex.com/cgi-bin/wiki.pl?$1', 0, 0),
('lasvegaswiki', 'http://wiki.gmnow.com/index.php/$1', 0, 0),
('linuxwiki', 'http://www.linuxwiki.de/$1', 0, 0),
('lojban', 'http://www.lojban.org/tiki/tiki-index.php?page=$1', 0, 0),
('lqwiki', 'http://wiki.linuxquestions.org/wiki/$1', 0, 0),
('lugkr', 'http://lug-kr.sourceforge.net/cgi-bin/lugwiki.pl?$1', 0, 0),
('lutherwiki', 'http://www.lutheranarchives.com/mw/index.php/$1', 0, 0),
('mathsongswiki', 'http://SeedWiki.com/page.cfm?wikiid=237&doc=$1', 0, 0),
('mbtest', 'http://www.usemod.com/cgi-bin/mbtest.pl?$1', 0, 0),
('meatball', 'http://www.usemod.com/cgi-bin/mb.pl?$1', 0, 0),
('mediawikiwiki', 'http://www.mediawiki.org/wiki/$1', 0, 0),
('mediazilla', 'http://bugzilla.wikipedia.org/$1', 1, 0),
('memoryalpha', 'http://www.memory-alpha.org/en/index.php/$1', 0, 0),
('metaweb', 'http://www.metaweb.com/wiki/wiki.phtml?title=$1', 0, 0),
('metawiki', 'http://sunir.org/apps/meta.pl?$1', 0, 0),
('metawikipedia', 'http://meta.wikimedia.org/wiki/$1', 0, 0),
('moinmoin', 'http://purl.net/wiki/moin/$1', 0, 0),
('mozillawiki', 'http://wiki.mozilla.org/index.php/$1', 0, 0),
('muweb', 'http://www.dunstable.com/scripts/MuWebWeb?$1', 0, 0),
('netvillage', 'http://www.netbros.com/?$1', 0, 0),
('oeis', 'http://www.research.att.com/cgi-bin/access.cgi/as/njas/sequences/eisA.cgi?Anum=$1', 0, 0),
('openfacts', 'http://openfacts.berlios.de/index.phtml?title=$1', 0, 0),
('openwiki', 'http://openwiki.com/?$1', 0, 0),
('opera7wiki', 'http://nontroppo.org/wiki/$1', 0, 0),
('orgpatterns', 'http://www.bell-labs.com/cgi-user/OrgPatterns/OrgPatterns?$1', 0, 0),
('osi reference model', 'http://wiki.tigma.ee/', 0, 0),
('pangalacticorg', 'http://www.pangalactic.org/Wiki/$1', 0, 0),
('patwiki', 'http://gauss.ffii.org/$1', 0, 0),
('personaltelco', 'http://www.personaltelco.net/index.cgi/$1', 0, 0),
('phpwiki', 'http://phpwiki.sourceforge.net/phpwiki/index.php?$1', 0, 0),
('pikie', 'http://pikie.darktech.org/cgi/pikie?$1', 0, 0),
('pmeg', 'http://www.bertilow.com/pmeg/$1.php', 0, 0),
('ppr', 'http://c2.com/cgi/wiki?$1', 0, 0),
('purlnet', 'http://purl.oclc.org/NET/$1', 0, 0),
('pythoninfo', 'http://www.python.org/cgi-bin/moinmoin/$1', 0, 0),
('pythonwiki', 'http://www.pythonwiki.de/$1', 0, 0),
('pywiki', 'http://www.voght.com/cgi-bin/pywiki?$1', 0, 0),
('raec', 'http://www.raec.clacso.edu.ar:8080/raec/Members/raecpedia/$1', 0, 0),
('revo', 'http://purl.org/NET/voko/revo/art/$1.html', 0, 0),
('rfc', 'http://www.rfc-editor.org/rfc/rfc$1.txt', 0, 0),
('s23wiki', 'http://is-root.de/wiki/index.php/$1', 0, 0),
('scoutpedia', 'http://www.scoutpedia.info/index.php/$1', 0, 0),
('seapig', 'http://www.seapig.org/$1', 0, 0),
('seattlewiki', 'http://seattlewiki.org/wiki/$1', 0, 0),
('seattlewireless', 'http://seattlewireless.net/?$1', 0, 0),
('seeds', 'http://www.IslandSeeds.org/wiki/$1', 0, 0),
('senseislibrary', 'http://senseis.xmp.net/?$1', 0, 0),
('shakti', 'http://cgi.algonet.se/htbin/cgiwrap/pgd/ShaktiWiki/$1', 0, 0),
('slashdot', 'http://slashdot.org/article.pl?sid=$1', 0, 0),
('smikipedia', 'http://www.smikipedia.org/$1', 0, 0),
('sockwiki', 'http://wiki.socklabs.com/$1', 0, 0),
('sourceforge', 'http://sourceforge.net/$1', 0, 0),
('squeak', 'http://minnow.cc.gatech.edu/squeak/$1', 0, 0),
('strikiwiki', 'http://ch.twi.tudelft.nl/~mostert/striki/teststriki.pl?$1', 0, 0),
('susning', 'http://www.susning.nu/$1', 0, 0),
('svgwiki', 'http://www.protocol7.com/svg-wiki/default.asp?$1', 0, 0),
('tavi', 'http://tavi.sourceforge.net/$1', 0, 0),
('tejo', 'http://www.tejo.org/vikio/$1', 0, 0),
('terrorwiki', 'http://www.liberalsagainstterrorism.com/wiki/index.php/$1', 0, 0),
('theopedia', 'http://www.theopedia.com/$1', 0, 0),
('tmbw', 'http://www.tmbw.net/wiki/index.php/$1', 0, 0),
('tmnet', 'http://www.technomanifestos.net/?$1', 0, 0),
('tmwiki', 'http://www.EasyTopicMaps.com/?page=$1', 0, 0),
('turismo', 'http://www.tejo.org/turismo/$1', 0, 0),
('twiki', 'http://twiki.org/cgi-bin/view/$1', 0, 0),
('twistedwiki', 'http://purl.net/wiki/twisted/$1', 0, 0),
('uea', 'http://www.tejo.org/uea/$1', 0, 0),
('unreal', 'http://wiki.beyondunreal.com/wiki/$1', 0, 0),
('ursine', 'http://wiki.ursine.ca/$1', 0, 0),
('usej', 'http://www.tejo.org/usej/$1', 0, 0),
('usemod', 'http://www.usemod.com/cgi-bin/wiki.pl?$1', 0, 0),
('visualworks', 'http://wiki.cs.uiuc.edu/VisualWorks/$1', 0, 0),
('warpedview', 'http://www.warpedview.com/index.php/$1', 0, 0),
('webdevwikinl', 'http://www.promo-it.nl/WebDevWiki/index.php?page=$1', 0, 0),
('webisodes', 'http://www.webisodes.org/$1', 0, 0),
('webseitzwiki', 'http://webseitz.fluxent.com/wiki/$1', 0, 0),
('why', 'http://clublet.com/c/c/why?$1', 0, 0),
('wiki', 'http://c2.com/cgi/wiki?$1', 0, 0),
('wikia', 'http://www.wikia.com/wiki/$1', 0, 0),
('wikibooks', 'http://en.wikibooks.org/wiki/$1', 1, 0),
('wikicities', 'http://www.wikicities.com/index.php/$1', 0, 0),
('wikif1', 'http://www.wikif1.org/$1', 0, 0),
('wikihow', 'http://www.wikihow.com/$1', 0, 0),
('wikimedia', 'http://wikimediafoundation.org/wiki/$1', 0, 0),
('wikinews', 'http://en.wikinews.org/wiki/$1', 0, 0),
('wikinfo', 'http://www.wikinfo.org/wiki.php?title=$1', 0, 0),
('wikipedia', 'http://en.wikipedia.org/wiki/$1', 1, 0),
('wikiquote', 'http://en.wikiquote.org/wiki/$1', 1, 0),
('wikisource', 'http://sources.wikipedia.org/wiki/$1', 1, 0),
('wikispecies', 'http://species.wikipedia.org/wiki/$1', 1, 0),
('wikitravel', 'http://wikitravel.org/en/$1', 0, 0),
('wikiworld', 'http://WikiWorld.com/wiki/index.php/$1', 0, 0),
('wikt', 'http://en.wiktionary.org/wiki/$1', 1, 0),
('wiktionary', 'http://en.wiktionary.org/wiki/$1', 1, 0),
('wlug', 'http://www.wlug.org.nz/$1', 0, 0),
('wlwiki', 'http://winslowslair.supremepixels.net/wiki/index.php/$1', 0, 0),
('ypsieyeball', 'http://sknkwrks.dyndns.org:1957/writewiki/wiki.pl?$1', 0, 0),
('zwiki', 'http://www.zwiki.org/$1', 0, 0),
('zzz wiki', 'http://wiki.zzz.ee/', 0, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_ipblocks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_ipblocks` (
  `ipb_id` int(8) NOT NULL auto_increment,
  `ipb_address` tinyblob NOT NULL,
  `ipb_user` int(8) unsigned NOT NULL default '0',
  `ipb_by` int(8) unsigned NOT NULL default '0',
  `ipb_reason` tinyblob NOT NULL,
  `ipb_timestamp` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `ipb_auto` tinyint(1) NOT NULL default '0',
  `ipb_anon_only` tinyint(1) NOT NULL default '0',
  `ipb_create_account` tinyint(1) NOT NULL default '1',
  `ipb_enable_autoblock` tinyint(1) NOT NULL default '1',
  `ipb_expiry` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `ipb_range_start` tinyblob NOT NULL,
  `ipb_range_end` tinyblob NOT NULL,
  `ipb_deleted` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`ipb_id`),
  UNIQUE KEY `ipb_address` (`ipb_address`(255),`ipb_user`,`ipb_auto`,`ipb_anon_only`),
  KEY `ipb_user` (`ipb_user`),
  KEY `ipb_range` (`ipb_range_start`(8),`ipb_range_end`(8)),
  KEY `ipb_timestamp` (`ipb_timestamp`),
  KEY `ipb_expiry` (`ipb_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_ipblocks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_job`
-- 

CREATE TABLE IF NOT EXISTS `wiki_job` (
  `job_id` int(9) unsigned NOT NULL auto_increment,
  `job_cmd` varchar(255) NOT NULL default '',
  `job_namespace` int(11) NOT NULL,
  `job_title` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `job_params` blob NOT NULL,
  PRIMARY KEY  (`job_id`),
  KEY `job_cmd` (`job_cmd`,`job_namespace`,`job_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_job`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_langlinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_langlinks` (
  `ll_from` int(8) unsigned NOT NULL default '0',
  `ll_lang` varchar(10) character set utf8 collate utf8_bin NOT NULL default '',
  `ll_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  UNIQUE KEY `ll_from` (`ll_from`,`ll_lang`),
  KEY `ll_lang` (`ll_lang`,`ll_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_langlinks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_logging`
-- 

CREATE TABLE IF NOT EXISTS `wiki_logging` (
  `log_type` char(10) NOT NULL default '',
  `log_action` char(10) NOT NULL default '',
  `log_timestamp` char(14) NOT NULL default '19700101000000',
  `log_user` int(10) unsigned NOT NULL default '0',
  `log_namespace` int(11) NOT NULL default '0',
  `log_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `log_comment` varchar(255) NOT NULL default '',
  `log_params` blob NOT NULL,
  `log_id` int(10) unsigned NOT NULL auto_increment,
  `log_deleted` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY  (`log_id`),
  KEY `type_time` (`log_type`,`log_timestamp`),
  KEY `user_time` (`log_user`,`log_timestamp`),
  KEY `page_time` (`log_namespace`,`log_title`,`log_timestamp`),
  KEY `times` (`log_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_logging`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_math`
-- 

CREATE TABLE IF NOT EXISTS `wiki_math` (
  `math_inputhash` varchar(16) NOT NULL,
  `math_outputhash` varchar(16) NOT NULL,
  `math_html_conservativeness` tinyint(1) NOT NULL,
  `math_html` text,
  `math_mathml` text,
  UNIQUE KEY `math_inputhash` (`math_inputhash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_math`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_objectcache`
-- 

CREATE TABLE IF NOT EXISTS `wiki_objectcache` (
  `keyname` char(255) character set utf8 collate utf8_bin NOT NULL default '',
  `value` mediumblob,
  `exptime` datetime default NULL,
  UNIQUE KEY `keyname` (`keyname`),
  KEY `exptime` (`exptime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_objectcache`
-- 

INSERT INTO `wiki_objectcache` (`keyname`, `value`, `exptime`) VALUES 
(0x737072696e672d77696b695f3a6d65737361676573, 0x4bb432b4aa2eb632b7520a730d0af6f4f753b2ceb432b4ae0500, '2007-10-25 22:36:52'),
(0x737072696e672d77696b695f3a7063616368653a6964686173683a312d30213121302121656e2132, 0xa555c96edb3010bdfb2b681eda93b5395e4acb2a8aa04d02c4498ab8eda1280cda1a5b44284a10a92a41907fef90b15ddb41d12c80176896c7f76686a34b16468c5ef14a4375599bb23694850376af598fd17c0ab7868e34c6f48e188dcb249e8b15fe24134805ff216e04c9b82673004574bd5880d6cb5aca3b2294365c4a48bdd89f27f8c5b456ec2340991c174ad7d21093018939c92a588e69664cc97c3f07c3bd0671737b8057542bdf3ef9a7204b86890694d1942c24d77a4c911d548a4b622c4f628491f052a80ae498aa625948593434f9867578afc9492d52887d9e906551a11afccdb9118522f8a9b5502b47df02125d2c4dc32bf09cc0164a523c471e27600c06ceb01295819426162fcea224d625575b0da9301a16169b263fb7f5f01b5fa8146ebd322b3f3e0a9b70a166577c05ef785e8eb84b19db74f7bcc61887db3a7c4617599b1959b3215b3636d332fa15fb964f42f668e54d27039e4aa1802687c9649d12fba8a615d73289a5489e34b3691acf15df96e9690396625557aea833fd88ffcccebe06f7a0cd7b61641346a4d0ae26d84914f462515f3e7d7dbb02077240f7ef7543ef7f08e65cc883b9b7a69c2bdfcab3b3ec6fcfee70a58a5a2de09977ea95d8ff94830ee01a8845b10376d0001f47abd58adb9d0eb9e6bf71f08422a5db5564c117ee029a8cdcc01dd16585f91d7bee8c95cec9448acb296361276887eda0dd06d58e0857298aca0147392f4914048330888ea2a8dbef45a4d3495a6edfe1b6cbcfb95ad578ddce85bad174c459c0ee1fd017a2ef981b581595805dc7c03a70b1e03dd597329df09558d0d19c0516317059486b8a876fced83fde5a8718f61d2a6dd7c1c82de1d0eb7b21dd404c6d3f366b190df6af6fc91e9074b190971289eed82dc5b31c45edc65ab19fd76ddfe21cd977c011ba5eb44e47828596f680bde1b2ae41bac36781d8fbb2cee887ec8d93ea8036f53b9d4eceddfcefd4fa03daafebf9a1d90dc50534d7eb4dbedbf58be2c4be0aabbb3deb296ed73303f993a66d667377468261340c7bdd6e6f48470f7f00, '2007-10-25 22:36:52');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_oldimage`
-- 

CREATE TABLE IF NOT EXISTS `wiki_oldimage` (
  `oi_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `oi_archive_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `oi_size` int(8) unsigned NOT NULL default '0',
  `oi_width` int(5) NOT NULL default '0',
  `oi_height` int(5) NOT NULL default '0',
  `oi_bits` int(3) NOT NULL default '0',
  `oi_description` tinyblob NOT NULL,
  `oi_user` int(5) unsigned NOT NULL default '0',
  `oi_user_text` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `oi_timestamp` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  KEY `oi_name` (`oi_name`(10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_oldimage`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_page`
-- 

CREATE TABLE IF NOT EXISTS `wiki_page` (
  `page_id` int(8) unsigned NOT NULL auto_increment,
  `page_namespace` int(11) NOT NULL,
  `page_title` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `page_restrictions` tinyblob NOT NULL,
  `page_counter` bigint(20) unsigned NOT NULL default '0',
  `page_is_redirect` tinyint(1) unsigned NOT NULL default '0',
  `page_is_new` tinyint(1) unsigned NOT NULL default '0',
  `page_random` double unsigned NOT NULL,
  `page_touched` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `page_latest` int(8) unsigned NOT NULL,
  `page_len` int(8) unsigned NOT NULL,
  PRIMARY KEY  (`page_id`),
  UNIQUE KEY `name_title` (`page_namespace`,`page_title`),
  KEY `page_random` (`page_random`),
  KEY `page_len` (`page_len`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_page`
-- 

INSERT INTO `wiki_page` (`page_id`, `page_namespace`, `page_title`, `page_restrictions`, `page_counter`, `page_is_redirect`, `page_is_new`, `page_random`, `page_touched`, `page_latest`, `page_len`) VALUES 
(1, 0, 0x4d61696e5f50616765, '', 220, 0, 0, 0.948748739561, 0x3230303730383238313533333538, 5, 444),
(2, 0, 0x53637265656e73686f7473, '', 22, 0, 1, 0.136096658663, 0x3230303730363035313330303132, 2, 22),
(3, 0, 0x506c617965725f6775696465, '', 6, 0, 1, 0.709090090764, 0x3230303730363038313331353536, 3, 22551);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_pagelinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_pagelinks` (
  `pl_from` int(8) unsigned NOT NULL default '0',
  `pl_namespace` int(11) NOT NULL default '0',
  `pl_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  UNIQUE KEY `pl_from` (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_pagelinks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_page_restrictions`
-- 

CREATE TABLE IF NOT EXISTS `wiki_page_restrictions` (
  `pr_page` int(8) NOT NULL,
  `pr_type` varchar(255) NOT NULL,
  `pr_level` varchar(255) NOT NULL,
  `pr_cascade` tinyint(4) NOT NULL,
  `pr_user` int(8) default NULL,
  `pr_expiry` char(14) character set utf8 collate utf8_bin default NULL,
  `pr_id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`pr_page`,`pr_type`),
  UNIQUE KEY `pr_id` (`pr_id`),
  KEY `pr_page` (`pr_page`),
  KEY `pr_typelevel` (`pr_type`,`pr_level`),
  KEY `pr_level` (`pr_level`),
  KEY `pr_cascade` (`pr_cascade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_page_restrictions`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_querycache`
-- 

CREATE TABLE IF NOT EXISTS `wiki_querycache` (
  `qc_type` char(32) NOT NULL,
  `qc_value` int(5) unsigned NOT NULL default '0',
  `qc_namespace` int(11) NOT NULL default '0',
  `qc_title` char(255) character set utf8 collate utf8_bin NOT NULL default '',
  KEY `qc_type` (`qc_type`,`qc_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_querycache`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_querycachetwo`
-- 

CREATE TABLE IF NOT EXISTS `wiki_querycachetwo` (
  `qcc_type` char(32) NOT NULL,
  `qcc_value` int(5) unsigned NOT NULL default '0',
  `qcc_namespace` int(11) NOT NULL default '0',
  `qcc_title` char(255) character set utf8 collate utf8_bin NOT NULL default '',
  `qcc_namespacetwo` int(11) NOT NULL default '0',
  `qcc_titletwo` char(255) character set utf8 collate utf8_bin NOT NULL default '',
  KEY `qcc_type` (`qcc_type`,`qcc_value`),
  KEY `qcc_title` (`qcc_type`,`qcc_namespace`,`qcc_title`),
  KEY `qcc_titletwo` (`qcc_type`,`qcc_namespacetwo`,`qcc_titletwo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_querycachetwo`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_querycache_info`
-- 

CREATE TABLE IF NOT EXISTS `wiki_querycache_info` (
  `qci_type` varchar(32) NOT NULL default '',
  `qci_timestamp` char(14) NOT NULL default '19700101000000',
  UNIQUE KEY `qci_type` (`qci_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_querycache_info`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_recentchanges`
-- 

CREATE TABLE IF NOT EXISTS `wiki_recentchanges` (
  `rc_id` int(8) NOT NULL auto_increment,
  `rc_timestamp` varchar(14) character set utf8 collate utf8_bin NOT NULL default '',
  `rc_cur_time` varchar(14) character set utf8 collate utf8_bin NOT NULL default '',
  `rc_user` int(10) unsigned NOT NULL default '0',
  `rc_user_text` varchar(255) character set utf8 collate utf8_bin NOT NULL,
  `rc_namespace` int(11) NOT NULL default '0',
  `rc_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `rc_comment` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `rc_minor` tinyint(3) unsigned NOT NULL default '0',
  `rc_bot` tinyint(3) unsigned NOT NULL default '0',
  `rc_new` tinyint(3) unsigned NOT NULL default '0',
  `rc_cur_id` int(10) unsigned NOT NULL default '0',
  `rc_this_oldid` int(10) unsigned NOT NULL default '0',
  `rc_last_oldid` int(10) unsigned NOT NULL default '0',
  `rc_type` tinyint(3) unsigned NOT NULL default '0',
  `rc_moved_to_ns` tinyint(3) unsigned NOT NULL default '0',
  `rc_moved_to_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `rc_patrolled` tinyint(3) unsigned NOT NULL default '0',
  `rc_ip` char(15) NOT NULL default '',
  `rc_old_len` int(10) default NULL,
  `rc_new_len` int(10) default NULL,
  `rc_deleted` tinyint(1) unsigned NOT NULL default '0',
  `rc_logid` int(10) unsigned NOT NULL default '0',
  `rc_log_type` varchar(255) character set utf8 collate utf8_bin default NULL,
  `rc_log_action` varchar(255) character set utf8 collate utf8_bin default NULL,
  `rc_params` blob NOT NULL,
  PRIMARY KEY  (`rc_id`),
  KEY `rc_timestamp` (`rc_timestamp`),
  KEY `rc_namespace_title` (`rc_namespace`,`rc_title`),
  KEY `rc_cur_id` (`rc_cur_id`),
  KEY `new_name_timestamp` (`rc_new`,`rc_namespace`,`rc_timestamp`),
  KEY `rc_ip` (`rc_ip`),
  KEY `rc_ns_usertext` (`rc_namespace`,`rc_user_text`),
  KEY `rc_user_text` (`rc_user_text`,`rc_timestamp`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_recentchanges`
-- 

INSERT INTO `wiki_recentchanges` (`rc_id`, `rc_timestamp`, `rc_cur_time`, `rc_user`, `rc_user_text`, `rc_namespace`, `rc_title`, `rc_comment`, `rc_minor`, `rc_bot`, `rc_new`, `rc_cur_id`, `rc_this_oldid`, `rc_last_oldid`, `rc_type`, `rc_moved_to_ns`, `rc_moved_to_title`, `rc_patrolled`, `rc_ip`, `rc_old_len`, `rc_new_len`, `rc_deleted`, `rc_logid`, `rc_log_type`, `rc_log_action`, `rc_params`) VALUES 
(1, 0x3230303730363035313330303132, 0x3230303730363035313330303132, 0, 0x3132372e302e302e31, 0, 0x53637265656e73686f7473, 0x4e657720706167653a20436f6f6c2073637265656e73686f7473206865726521, 0, 0, 1, 2, 2, 0, 1, 0, '', 0, '127.0.0.1', 0, 22, 0, 0, NULL, NULL, ''),
(2, 0x3230303730363038313331353536, 0x3230303730363038313331353536, 0, 0x3132372e302e302e31, 0, 0x506c617965725f6775696465, 0x4e657720706167653a203c21444f43545950452068746d6c205055424c494320222d2f2f5733432f2f4454442048544d4c20342e3031205472616e736974696f6e616c2f2f454e223e20203c68746d6c3e20203c686561643e202020203c6d65746120636f6e74656e743d22746578742f68746d6c3b20636861727365743d49534f2d383835392d312220687474702d65717569763d22636f6e74656e742d74797065223e203c4c494e4b2052454c3d227374796c65736865657422204d454449413d2273632e2e2e, 0, 0, 1, 3, 3, 0, 1, 0, '', 0, '127.0.0.1', 0, 22551, 0, 0, NULL, NULL, ''),
(3, 0x3230303730363038313433303437, 0x3230303730363038313433303437, 0, 0x3132372e302e302e31, 0, 0x4d61696e5f50616765, '', 0, 0, 0, 1, 4, 1, 0, 0, '', 0, '127.0.0.1', 444, 460, 0, 0, NULL, NULL, ''),
(4, 0x3230303730383238313533333538, 0x3230303730383238313533333538, 2, 0x5573657231, 0, 0x4d61696e5f50616765, '', 0, 0, 0, 1, 5, 4, 0, 0, '', 0, '127.0.0.1', 460, 444, 0, 0, NULL, NULL, '');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_redirect`
-- 

CREATE TABLE IF NOT EXISTS `wiki_redirect` (
  `rd_from` int(8) unsigned NOT NULL default '0',
  `rd_namespace` int(11) NOT NULL default '0',
  `rd_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  PRIMARY KEY  (`rd_from`),
  KEY `rd_ns_title` (`rd_namespace`,`rd_title`,`rd_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_redirect`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_revision`
-- 

CREATE TABLE IF NOT EXISTS `wiki_revision` (
  `rev_id` int(8) unsigned NOT NULL auto_increment,
  `rev_page` int(8) unsigned NOT NULL,
  `rev_text_id` int(8) unsigned NOT NULL,
  `rev_comment` tinyblob NOT NULL,
  `rev_user` int(5) unsigned NOT NULL default '0',
  `rev_user_text` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `rev_timestamp` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `rev_minor_edit` tinyint(1) unsigned NOT NULL default '0',
  `rev_deleted` tinyint(1) unsigned NOT NULL default '0',
  `rev_len` int(8) unsigned default NULL,
  `rev_parent_id` int(8) unsigned default NULL,
  PRIMARY KEY  (`rev_page`,`rev_id`),
  UNIQUE KEY `rev_id` (`rev_id`),
  KEY `rev_timestamp` (`rev_timestamp`),
  KEY `page_timestamp` (`rev_page`,`rev_timestamp`),
  KEY `user_timestamp` (`rev_user`,`rev_timestamp`),
  KEY `usertext_timestamp` (`rev_user_text`,`rev_timestamp`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 MAX_ROWS=10000000 AVG_ROW_LENGTH=1024 AUTO_INCREMENT=6 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_revision`
-- 

INSERT INTO `wiki_revision` (`rev_id`, `rev_page`, `rev_text_id`, `rev_comment`, `rev_user`, `rev_user_text`, `rev_timestamp`, `rev_minor_edit`, `rev_deleted`, `rev_len`, `rev_parent_id`) VALUES 
(1, 1, 1, '', 0, 0x4d6564696157696b692064656661756c74, 0x3230303730363034313233373338, 0, 0, 444, NULL),
(4, 1, 4, '', 0, 0x3132372e302e302e31, 0x3230303730363038313433303437, 0, 0, 460, NULL),
(5, 1, 5, '', 2, 0x5573657231, 0x3230303730383238313533333538, 0, 0, 444, NULL),
(2, 2, 2, 0x4e657720706167653a20436f6f6c2073637265656e73686f7473206865726521, 0, 0x3132372e302e302e31, 0x3230303730363035313330303132, 0, 0, 22, NULL),
(3, 3, 3, 0x4e657720706167653a203c21444f43545950452068746d6c205055424c494320222d2f2f5733432f2f4454442048544d4c20342e3031205472616e736974696f6e616c2f2f454e223e20203c68746d6c3e20203c686561643e202020203c6d65746120636f6e74656e743d22746578742f68746d6c3b20636861727365743d49534f2d383835392d312220687474702d65717569763d22636f6e74656e742d74797065223e203c4c494e4b2052454c3d227374796c65736865657422204d454449413d2273632e2e2e, 0, 0x3132372e302e302e31, 0x3230303730363038313331353536, 0, 0, 22551, NULL);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_searchindex`
-- 

CREATE TABLE IF NOT EXISTS `wiki_searchindex` (
  `si_page` int(8) unsigned NOT NULL,
  `si_title` varchar(255) NOT NULL default '',
  `si_text` mediumtext NOT NULL,
  UNIQUE KEY `si_page` (`si_page`),
  FULLTEXT KEY `si_title` (`si_title`),
  FULLTEXT KEY `si_text` (`si_text`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_searchindex`
-- 

INSERT INTO `wiki_searchindex` (`si_page`, `si_title`, `si_text`) VALUES 
(2, 'screenshots', ' cool screenshots here '),
(3, 'player guide', ' doctype html public - w3c dtd html 4 01 transitional en getting started ta spring mini-help what is ta spring getting started q&amp;a more useful information legal getting started table of contents 1 getting to your first game 1 1 step 1 is your computer ready 1 2 step 2 download the current installer 1 3 step 3 make sure the game works on your computer game controls 1 4 step 4 playing online - tasclient exe 1 5 step 5 hosting online - tasclient exe getting to your first game step 1 is your computer ready currently spring is only compatible with windows operating systems in theory it it''s compatible with all 9x or later oses but since we''re still beta we''ll call it hit and miss there is a linux port in the works and you can join the mailinglist if you would like to know how it it''s progressing you will need some kind of 3d hardware acceleration it needs to have the latest opengl drivers which means providing the card is recent enough the latest drivers from your cards manufacturer you will also need directx &nbsp; installed step 2 download the current installer click here &nbsp; to go to the downloads page download the regular installer option run it and install it somewhere on your computer in theory if at this point you read the stuff in the docs folder then you will know what to do next step 3 make sure the game works on your computer browse to the installation folder and double-click spring exe choose yes on the do you want to be a server dialog choose the commanders script with the arrow keys and enter choose a map with the arrow keys and enter press enter to force start the game don''t bother going online until you figure out how to make your commander build buildings and your buildings build units and manage to find and kill the other commander on the map and get the you win message spring supports ai plugins which allow for external ai programs to be used there is currently one ai included in the download but you can find more singleplayer ais on the ai forum if you start the spring exe application directly you will get to choose between these global ai ai''s you can also use the lobby client to create a battle with ai bots in it game controls camera controls move the camera with the arrow keys or by placing the mouse curser at the screen borders holding shift makes the camera move faster and holding ctrl makes it slower turn on mouselook with mouse button 3 or backspace use ctrl mouse3 to toggle between the camera modes available key assignments you can configure the assignment of keys by editing the file uikeys txt and by running the selectionkeys editor these are the default key bindings camera controls function mouse 1 selects units drag to select a group double click to select units of the same type gives order if a specific order has been selected mouse 2 gives the default order for the unit mouse 3 toggles mouse look ctrl mouse 3 toggles camera mode arrow keys moves the camera ctrl shift increases decreases camera movement speed mousewheel moves the camera up down t&nbsp; &nbsp;track a selected unit c take direct control of a selected unit f3 jump to last message location general function f1 toggles color coding of the map according to terrain elevation f4 toggles color coding of the map according to the metal density f12 screenshot - increases decreases game speed pause pauses the game enter used to send chat messages b toggles the display of debug information &sect; &nbsp; draw stuff in map that you and allies can see mouse1 lines mouse2 erase mouse3 marker doubleclick named marker h share interface l show los and radar info in map unit groups function 0-9 select ai group 0-9 ctrl 0-9 add current units to ai group 0-9 q selects an unnamed group from which at least one unit is selected ctrl q creates an unnamed ai group or selects an ai for an existing one shift q deletes the current ai group building buildings function shift drag mouse create a line of buildings shift ctrl drag create an axis aligned line of buildings shift ctrl click unit build a ring of buildings around existing unit shift alt drag build a box of buildings shift alt ctrl drag build a hollow box of buildings unit commands function m move ctrl keep relative distances among selected p patrol a attack s stop x toggle on off ctrl-d self destruct g guard k cloak d dgun e reclaim can take an area r repair can take an area l load can take an area u unload can take an area tips the repeat order option can be very usefull for example if you want to make a factory output an unlimited amount of units or if you want transport units to ferry units from one area to another indefinitly ballistic weapons maybe also other later on can now be set to fire in a high trajectory which can be usefull to shot over mountains etc but they will lose some accuracy we are not entirely sure if we will keep this option or not step 4 playing online - tasclient exe playing is quite simple just make sure you are connected to the internet then double-click on the tasclient icon it may have been put on your desktop but it will definitely be in your start menu once you are in the client app you will need to use the options button at the top of the window to set up an account from there just click the little button in the upper left section of the screen to connect to the server assuming your firewalls aren''t excessively paranoid it will make a noise and you will be put into the main discussion channel you can then choose a game from the bottom pane or chat in the top one step 5 hosting online - tasclient exe in order to host a game you must open the battle window by clicking on the battle screen button once there you will need to click on the host battle button the bar at the top defines the ammount of players you can have 2-16 next is the game game''s name followed by a dropdown box with a list of your currently installed mods the port the server will host on and if you wish to lock your server from outsiders- you can also add a password you''ve started your game people joined and you started it great but what if once you''re ingame everyone elses name is stays red for several mins that means they were unable to connect to your game oh noes this normally means you have a firewall blocking access to your computer from the outside consult if you need to know how to open ports on your router choose any game in the list it doesn''t matter just be sure to use the port 8245 instead of what the game game''s listing says to use -- saved in parser cache with key spring pcache idhash 1026-1 1 0 1 0 1 0 en and timestamp 20051021034628 -- retrieved from '),
(1, 'main page', '  mediawiki has been successfully installed   consult the user user''s guide for information on using the wiki software getting started getting started getting started configuration settings list mediawiki faq mediawiki release mailing list ');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_site_stats`
-- 

CREATE TABLE IF NOT EXISTS `wiki_site_stats` (
  `ss_row_id` int(8) unsigned NOT NULL,
  `ss_total_views` bigint(20) unsigned default '0',
  `ss_total_edits` bigint(20) unsigned default '0',
  `ss_good_articles` bigint(20) unsigned default '0',
  `ss_total_pages` bigint(20) default '-1',
  `ss_users` bigint(20) default '-1',
  `ss_admins` int(10) default '-1',
  `ss_images` int(10) default '0',
  UNIQUE KEY `ss_row_id` (`ss_row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_site_stats`
-- 

INSERT INTO `wiki_site_stats` (`ss_row_id`, `ss_total_views`, `ss_total_edits`, `ss_good_articles`, `ss_total_pages`, `ss_users`, `ss_admins`, `ss_images`) VALUES 
(1, 341, 4, 0, 4, 2, -1, 0);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_templatelinks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_templatelinks` (
  `tl_from` int(8) unsigned NOT NULL default '0',
  `tl_namespace` int(11) NOT NULL default '0',
  `tl_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  UNIQUE KEY `tl_from` (`tl_from`,`tl_namespace`,`tl_title`),
  KEY `tl_namespace` (`tl_namespace`,`tl_title`,`tl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_templatelinks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_text`
-- 

CREATE TABLE IF NOT EXISTS `wiki_text` (
  `old_id` int(8) unsigned NOT NULL auto_increment,
  `old_text` mediumblob NOT NULL,
  `old_flags` tinyblob NOT NULL,
  PRIMARY KEY  (`old_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 MAX_ROWS=10000000 AVG_ROW_LENGTH=10240 AUTO_INCREMENT=6 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_text`
-- 

INSERT INTO `wiki_text` (`old_id`, `old_text`, `old_flags`) VALUES 
(1, 0x3c6269673e2727274d6564696157696b6920686173206265656e207375636365737366756c6c7920696e7374616c6c65642e2727273c2f6269673e0a0a436f6e73756c7420746865205b687474703a2f2f6d6574612e77696b696d656469612e6f72672f77696b692f48656c703a436f6e74656e7473205573657227732047756964655d20666f7220696e666f726d6174696f6e206f6e207573696e67207468652077696b6920736f6674776172652e0a0a3d3d2047657474696e672073746172746564203d3d0a0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a436f6e66696775726174696f6e5f73657474696e677320436f6e66696775726174696f6e2073657474696e6773206c6973745d0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a464151204d6564696157696b69204641515d0a2a205b687474703a2f2f6d61696c2e77696b696d656469612e6f72672f6d61696c6d616e2f6c697374696e666f2f6d6564696177696b692d616e6e6f756e6365204d6564696157696b692072656c65617365206d61696c696e67206c6973745d, 0x7574662d38),
(2, 0x436f6f6c2073637265656e73686f7473206865726521, 0x7574662d38),
(3, 0x3c21444f43545950452068746d6c205055424c494320222d2f2f5733432f2f4454442048544d4c20342e3031205472616e736974696f6e616c2f2f454e223e0a0a3c68746d6c3e0a0a3c686561643e0a0a20203c6d65746120636f6e74656e743d22746578742f68746d6c3b20636861727365743d49534f2d383835392d312220687474702d65717569763d22636f6e74656e742d74797065223e0a3c4c494e4b2052454c3d227374796c65736865657422204d454449413d2273637265656e2220545950453d22746578742f6373732220485245463d226373732f6d61696e2e637373223e0a0a20203c7469746c653e47657474696e6720537461727465643c2f7469746c653e0a0a3c2f686561643e0a0a3c626f64793e0a0a3c6831207374796c653d22746578742d616c69676e3a2063656e7465723b223e544120537072696e67206d696e692d68656c703c2f68313e0a0a3c7461626c65207374796c653d2277696474683a20313030253b20746578742d616c69676e3a206c6566743b2220626f726465723d2231222063656c6c70616464696e673d2232220a0a2063656c6c73706163696e673d2232223e0a0a20203c74626f64793e0a0a202020203c74723e0a0a2020202020203c7464207374796c653d2277696474683a203230253b20766572746963616c2d616c69676e3a20746f703b223e0a0a2020202020203c703e3c6120687265663d226d61696e2e68746d6c223e5768617420697320544120537072696e673f3c2f613e3c2f703e0a0a2020202020203c703e3c6120687265663d2247657474696e67253230537461727465642e68746d6c223e47657474696e672053746172746564213c2f613e3c2f703e0a0a2020202020203c703e3c6120687265663d225126616d703b412e68746d6c223e5126616d703b41213c2f613e3c2f703e0a0a2020202020203c703e3c6120687265663d224d6f7265253230496e666f2e68746d6c223e4d6f72652075736566756c20696e666f726d6174696f6e213c2f613e3c2f703e0a0a2020202020203c703e3c6120687265663d224c6567616c2e68746d6c223e4c6567616c213c2f613e3c2f703e0a0a2020202020203c2f74643e0a0a2020202020203c7464207374796c653d22766572746963616c2d616c69676e3a20746f703b223e0a0a2020202020203c6469762069643d22636f6e74656e74223e0a0a2020202020203c6469762069643d2261727469636c65223e0a0a2020202020203c683120636c6173733d22706167657469746c65223e47657474696e6720537461727465643c2f68313e0a0a2020202020203c7461626c652069643d22746f632220626f726465723d2230223e0a0a20202020202020203c74626f64793e0a0a202020202020202020203c74722069643d22746f637469746c65223e0a0a2020202020202020202020203c746420616c69676e3d2263656e746572223e3c623e5461626c65206f6620636f6e74656e74733c2f623e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74722069643d22746f63696e73696465223e0a0a2020202020202020202020203c74643e0a0a2020202020202020202020203c64697620636c6173733d22746f636c696e65223e3c6120687265663d222347657474696e675f546f5f596f75725f46697273745f47616d65223e310a0a47657474696e6720546f20596f75722046697273742047616d653c2f613e3c62723e0a0a2020202020202020202020203c2f6469763e0a0a2020202020202020202020203c64697620636c6173733d22746f63696e64656e74223e0a0a2020202020202020202020203c64697620636c6173733d22746f63696e64656e74223e0a0a2020202020202020202020203c70207374796c653d226d617267696e2d6c6566743a20343070783b223e3c610a0a20687265663d2223535445505f313a5f49735f796f75725f636f6d70757465725f72656164792e3346223e312e31205354455020313a0a0a497320796f757220636f6d70757465722072656164793f3c2f613e3c62723e0a0a2020202020202020202020203c6120687265663d2223535445505f323a5f446f776e6c6f61645f7468655f43757272656e745f496e7374616c6c6572223e312e3220535445500a0a323a20446f776e6c6f6164207468652043757272656e7420496e7374616c6c65723c2f613e3c62723e0a0a2020202020202020202020203c6120687265663d2223535445505f335f4d616b655f537572655f7468655f47616d655f576f726b735f6f6e5f596f75725f436f6d7075746572223e312e330a0a535445502033204d616b652053757265207468652047616d6520576f726b73206f6e20596f757220436f6d70757465723c2f613e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c646976207374796c653d226d617267696e2d6c6566743a20343070783b2220636c6173733d22746f63696e64656e74223e0a0a2020202020202020202020203c703e3c6120687265663d2223517569636b5f5374617274223e47616d6520436f6e74726f6c733c2f613e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f6469763e0a0a2020202020202020202020203c70207374796c653d226d617267696e2d6c6566743a20343070783b223e3c610a0a20687265663d2223535445505f343a5f506c6179696e675f4f6e6c696e655f2d5f544153436c69656e742e657865223e312e340a0a5354455020343a20506c6179696e67204f6e6c696e65202d20544153436c69656e742e6578653c2f613e3c62723e0a0a2020202020202020202020203c6120687265663d2223535445505f353a5f486f7374696e675f4f6e6c696e655f2d5f544153436c69656e742e657865223e312e3520535445500a0a353a20486f7374696e67204f6e6c696e65202d20544153436c69656e742e6578653c2f613e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f6469763e0a0a2020202020202020202020203c2f6469763e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a20202020202020203c2f74626f64793e0a0a2020202020203c2f7461626c653e0a0a2020202020203c61206e616d653d2247657474696e675f546f5f596f75725f46697273745f47616d65223e3c2f613e0a0a2020202020203c68313e47657474696e6720546f20596f75722046697273742047616d653c2f68313e0a0a2020202020203c61206e616d653d22535445505f313a5f49735f796f75725f636f6d70757465725f72656164792e3346223e3c2f613e0a0a2020202020203c68333e5354455020313a20497320796f757220636f6d70757465722072656164793f3c2f68333e0a0a2020202020203c703e43757272656e746c7920537072696e67206973206f6e6c7920636f6d70617469626c6520776974682057696e646f7773204f7065726174696e670a0a73797374656d732e0a0a496e207468656f72792c206974277320636f6d70617469626c65207769746820616c6c203978206f72206c61746572204f5365732c206275742073696e63652077652772650a0a7374696c6c20626574612c207765276c6c2063616c6c206974202268697420616e64206d697373222e203c2f703e0a0a2020202020203c703e54686572652069732061203c6120687265663d22687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f77696b692f4c696e7578220a0a207469746c653d224c696e7578223e4c696e757820506f72743c2f613e20696e2074686520776f726b732c20616e6420796f752063616e206a6f696e207468650a0a6d61696c696e676c69737420696620796f7520776f756c64206c696b6520746f206b6e6f7720686f7720697427732070726f6772657373696e672e203c2f703e0a0a2020202020203c703e596f752077696c6c206e65656420736f6d65206b696e64206f6620334420686172647761726520616363656c65726174696f6e2c206974206e656564730a0a746f0a0a6861766520746865206c6174657374204f70656e474c206472697665727320287768696368206d65616e732c2070726f766964696e672074686520636172642069730a0a726563656e7420656e6f7567682c20746865206c617465737420647269766572732066726f6d20796f7572206361726473206d616e756661637475726572292e20596f750a0a77696c6c20616c736f206e656564203c610a0a20687265663d22687474703a2f2f7777772e6d6963726f736f66742e636f6d2f77696e646f77732f646972656374782f64656661756c742e617370783f75726c3d2f77696e646f77732f646972656374782f646f776e6c6f6164732f64656661756c742e68746d220a0a20636c6173733d2265787465726e616c220a0a207469746c653d22687474703a2f2f7777772e6d6963726f736f66742e636f6d2f77696e646f77732f646972656374782f64656661756c742e617370783f75726c3d2f77696e646f77732f646972656374782f646f776e6c6f6164732f64656661756c742e68746d220a0a2072656c3d226e6f666f6c6c6f77223e446972656374583c2f613e3c7370616e20636c6173733d2275726c657870616e73696f6e223e266e6273703b283c693e687474703a2f2f7777772e6d6963726f736f66742e636f6d2f77696e646f77732f646972656374782f64656661756c742e617370783f75726c3d2f77696e646f77732f646972656374782f646f776e6c6f6164732f64656661756c742e68746d3c2f693e293c2f7370616e3e0a0a696e7374616c6c65642e203c2f703e0a0a2020202020203c61206e616d653d22535445505f323a5f446f776e6c6f61645f7468655f43757272656e745f496e7374616c6c6572223e3c2f613e0a0a2020202020203c68333e5354455020323a20446f776e6c6f6164207468652043757272656e7420496e7374616c6c65723c2f68333e0a0a2020202020203c703e3c6120687265663d22687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f646f776e6c6f61642e706870220a0a20636c6173733d2265787465726e616c22207469746c653d22687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f646f776e6c6f61642e706870220a0a2072656c3d226e6f666f6c6c6f77223e436c69636b20486572653c2f613e3c7370616e20636c6173733d2275726c657870616e73696f6e223e266e6273703b283c693e687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f646f776e6c6f61642e7068703c2f693e293c2f7370616e3e0a0a746f20676f20746f2074686520646f776e6c6f61647320706167652e20446f776e6c6f616420746865203c623e526567756c617220696e7374616c6c65723c2f623e0a0a6f7074696f6e2e2052756e20697420616e6420696e7374616c6c20697420736f6d657768657265206f6e20796f757220636f6d70757465722e20496e207468656f72792069662c0a0a6174207468697320706f696e742c20796f7520726561642074686520737475666620696e207468652022646f63732220666f6c6465722c207468656e20796f752077696c6c0a0a6b6e6f77207768617420746f20646f206e6578742e203c2f703e0a0a2020202020203c61206e616d653d22535445505f335f4d616b655f537572655f7468655f47616d655f576f726b735f6f6e5f596f75725f436f6d7075746572223e3c2f613e0a0a2020202020203c68333e535445502033204d616b652053757265207468652047616d6520576f726b73206f6e20596f757220436f6d70757465723c2f68333e0a0a2020202020203c703e42726f77736520746f2074686520696e7374616c6c6174696f6e20666f6c64657220616e6420646f75626c652d636c69636b0a0a22737072696e672e657865222e0a0a43686f6f7365202279657322206f6e207468652022646f20796f752077616e7420746f20626520612073657276657222206469616c6f672c2063686f6f7365207468650a0a22436f6d6d616e646572732220736372697074207769746820746865206172726f77206b65797320616e6420656e7465722c2063686f6f73652061206d617020776974680a0a746865206172726f77206b65797320616e6420656e7465722c20707265737320656e74657220746f20666f726365207374617274207468652067616d652e203c2f703e0a0a2020202020203c703e446f6e277420626f7468657220676f696e67206f6e6c696e6520756e74696c20796f7520666967757265206f757420686f7720746f206d616b650a0a796f75720a0a436f6d6d616e646572206275696c64206275696c64696e677320616e6420796f7572206275696c64696e6773206275696c6420756e6974732c20616e64206d616e61676520746f0a0a66696e6420616e64206b696c6c20746865206f7468657220436f6d6d616e646572206f6e20746865206d617020616e6420676574207468652022596f752057696e220a0a6d6573736167652e203c2f703e0a0a0a0a3c703e537072696e6720737570706f72747320414920706c7567696e732c20776869636820616c6c6f7720666f722065787465726e616c2041492070726f6772616d7320746f20626520757365642e2054686572652069732063757272656e746c79206f6e6520414920696e636c7564656420696e2074686520646f776e6c6f61642c2062757420796f752063616e2066696e64206d6f72652073696e676c65706c6179657220414973206f6e2074686520414920666f72756d2e20496620796f752073746172742074686520737072696e672e657865206170706c69636174696f6e206469726563746c792c20796f752077696c6c2067657420746f2063686f6f7365206265747765656e20746865736520476c6f62616c20414927732e20596f752063616e20616c736f2075736520746865206c6f62627920636c69656e7420746f20637265617465206120626174746c6520776974682041492028426f74732920696e2069742e3c2f703e0a0a0a0a2020202020203c61206e616d653d22517569636b5f5374617274223e3c2f613e0a0a2020202020203c6831207374796c653d22636f6c6f723a20726762283235352c20302c2030293b223e47616d6520436f6e74726f6c733c2f68313e0a0a2020202020203c7461626c65207374796c653d22706167652d627265616b2d6265666f72653a20616c776179733b2220626f726465723d2230220a0a2063656c6c70616464696e673d2230222063656c6c73706163696e673d2230222077696474683d22383030223e0a0a20202020202020203c74626f64793e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2236222077696474683d22383030223e0a0a2020202020202020202020203c68323e43616d65726120636f6e74726f6c733c2f68323e0a0a2020202020202020202020203c703e4d6f7665207468652063616d657261207769746820746865206172726f77206b657973206f7220627920706c6163696e67207468650a0a6d6f75736520637572736572206174207468652073637265656e20626f72646572732e20486f6c64696e67207368696674206d616b6573207468652063616d657261206d6f76650a0a6661737465722c20616e6420686f6c64696e67206374726c206d616b657320697420736c6f7765722e205475726e206f6e206d6f7573656c6f6f6b2077697468206d6f7573650a0a627574746f6e203320286f72206261636b7370616365292e20557365206374726c2b6d6f7573653320746f20746f67676c65206265747765656e207468652063616d6572610a0a6d6f64657320617661696c61626c652e203c2f703e0a0a2020202020202020202020203c68323e4b65792061737369676e6d656e74733c2f68323e0a0a2020202020202020202020203c703e596f752063616e20636f6e666967757265207468652061737369676e6d656e74206f66206b6579732062792065646974696e67207468650a0a66696c652075696b6579732e7478742c20616e642062792072756e6e696e67207468652053656c656374696f6e6b65797320656469746f722e20546865736520617265207468650a0a64656661756c74206b65792062696e64696e67733a3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420726f777370616e3d223538222076616c69676e3d22746f70222077696474683d2235223e3c62723e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c7374726f6e673e43616d65726120636f6e74726f6c73203c2f7374726f6e673e203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c7374726f6e673e46756e6374696f6e3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420726f777370616e3d223538222076616c69676e3d22746f70222077696474683d2235223e3c62723e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2234222077696474683d22373930223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4d6f75736520313c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53656c6563747320756e6974732e204472616720746f2073656c65637420612067726f75702c20646f75626c6520636c69636b20746f0a0a73656c65637420756e697473206f66207468652073616d6520747970652e204769766573206f726465722069662061207370656369666963206f7264657220686173206265656e0a0a73656c65637465642e203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4d6f7573652032203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4769766573207468652064656661756c74206f7264657220666f722074686520756e6974203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4d6f7573652033203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c6573206d6f757365206c6f6f6b203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4374726c202b204d6f75736520333c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c65732063616d657261206d6f6465203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4172726f77206b657973203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4d6f766573207468652063616d657261203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4374726c2f73686966743c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e496e637265617365732f6465637265617365732063616d657261206d6f76656d656e74207370656564203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4d6f757365776865656c3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4d6f766573207468652063616d6572612075702f646f776e203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e54266e6273703b3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e266e6273703b547261636b20612073656c656374656420756e69743c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e433c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e54616b652064697265637420636f6e74726f6c206f6620612073656c656374656420756e69743c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e46333c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4a756d7020746f206c617374206d657373616765206c6f636174696f6e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c7374726f6e673e47656e6572616c3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c7374726f6e673e46756e6374696f6e3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2234222077696474683d22373930223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e46313c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c657320636f6c6f7220636f64696e67206f6620746865206d6170206163636f7264696e6720746f207465727261696e0a0a656c65766174696f6e203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e46343c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c657320636f6c6f7220636f64696e67206f6620746865206d6170206163636f7264696e6720746f20746865206d6574616c0a0a64656e736974793c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4631323c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53637265656e73686f743c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e2b2f2d3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e496e637265617365732f6465637265617365732067616d65207370656564203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e50617573653c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e506175736573207468652067616d65203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e456e7465723c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e5573656420746f2073656e642063686174206d65737361676573203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e423c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c65732074686520646973706c6179206f6620646562756720696e666f726d6174696f6e203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e26736563743b2f60266e6273703b3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4472617720737475666620696e206d6170207468617420796f7520616e6420616c6c6965732063616e207365650a0a286d6f757365313d6c696e65732c206d6f757365323d65726173652c206d6f757365333d6d61726b65722c646f75626c65636c69636b3d6e616d6564206d61726b6572293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e483c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e536861726520496e746572666163653c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4c3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53686f77206c6f7320616e6420726164617220696e666f20696e206d61703c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c7374726f6e673e556e69742067726f7570733c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c7374726f6e673e46756e6374696f6e3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2234222077696474683d22373930223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e302d393c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53656c6563742041492067726f757020302d39203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4374726c202b20302d393c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4164642063757272656e7420756e69747320746f2041492067726f757020302d39203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e513c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53656c6563747320616e20756e6e616d65642067726f75702066726f6d207768696368206174206c65617374206f6e6520756e69742069730a0a73656c6563746564203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4374726c202b2051203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4372656174657320616e20756e6e616d65642041492067726f7570206f722073656c6563747320616e20414920666f7220616e0a0a6578697374696e67206f6e65203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e5368696674202b2051203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e44656c65746573207468652063757272656e742041492067726f7570203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c7374726f6e673e4275696c64696e67206275696c64696e67733c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c7374726f6e673e46756e6374696f6e3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e53686966742b44726167206d6f7573653c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4372656174652061206c696e65206f66206275696c64696e67733c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e53686966742b4374726c2b447261673c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e43726561746520616e206178697320616c69676e6564206c696e65206f66206275696c64696e67733c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e53686966742b4374726c2b436c69636b20756e69743c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4275696c6420612072696e67206f66206275696c64696e67732061726f756e64206578697374696e6720756e69743c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e53686966742b416c742b447261673c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4275696c64206120626f78206f66206275696c64696e67733c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e53686966742b416c742b4374726c2b447261673c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4275696c64206120686f6c6c6f7720626f78206f66206275696c64696e67733c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c7374726f6e673e556e697420636f6d6d616e64733c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c7374726f6e673e46756e6374696f6e3c2f7374726f6e673e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c68723e203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4d3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4d6f766520284374726c3d6b6565702072656c61746976652064697374616e63657320616d6f6e672073656c6563746564293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e503c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e506174726f6c3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e413c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e41747461636b3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e533c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53746f703c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e583c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e546f67676c65206f6e2f6f66663c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4374726c2d443c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e53656c662064657374727563743c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e473c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e47756172643c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4b3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e436c6f616b3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e443c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4447756e3c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e453c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e5265636c61696d202843616e2074616b6520616e2061726561293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e523c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e526570616972202843616e2074616b6520616e2061726561293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e4c3c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e4c6f6164202843616e2074616b6520616e2061726561293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e553c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e556e6c6f6164202843616e2074616b6520616e2061726561293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22323334223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a2020202020202020202020203c746420636f6c7370616e3d2232222077696474683d22353536223e0a0a2020202020202020202020203c703e3c62723e0a0a2020202020202020202020203c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2236222077696474683d22383030223e0a0a2020202020202020202020203c68333e546970733c2f68333e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a202020202020202020203c74723e0a0a2020202020202020202020203c746420636f6c7370616e3d2236222077696474683d22383030223e0a0a2020202020202020202020203c703e54686520726570656174206f72646572206f7074696f6e2063616e20626520766572792075736566756c6c2e20466f72206578616d706c650a0a696620796f752077616e7420746f206d616b65206120666163746f7279206f757470757420616e20756e6c696d6974656420616d6f756e74206f6620756e697473206f722069660a0a796f752077616e74207472616e73706f727420756e69747320746f20666572727920756e6974732066726f6d206f6e65206172656120746f20616e6f746865720a0a696e646566696e69746c792e3c2f703e0a0a2020202020202020202020203c703e42616c6c697374696320776561706f6e73286d6179626520616c736f206f74686572206c61746572206f6e292063616e206e6f772062650a0a73657420746f206669726520696e20612068696768207472616a6563746f72792077686963682063616e2062652075736566756c6c20746f2073686f74206f7665720a0a6d6f756e7461696e73206574632062757420746865792077696c6c206c6f736520736f6d652061636375726163792e2028776520617265206e6f7420656e746972656c790a0a737572652069662077652077696c6c206b6565702074686973206f7074696f6e206f72206e6f74293c2f703e0a0a2020202020202020202020203c2f74643e0a0a202020202020202020203c2f74723e0a0a20202020202020203c2f74626f64793e0a0a2020202020203c2f7461626c653e0a0a2020202020203c703e203c2f703e0a0a2020202020203c61206e616d653d22535445505f343a5f506c6179696e675f4f6e6c696e655f2d5f544153436c69656e742e657865223e3c2f613e0a0a2020202020203c68333e5354455020343a20506c6179696e67204f6e6c696e65202d20544153436c69656e742e6578653c2f68333e0a0a2020202020203c703e506c6179696e672069732071756974652073696d706c652e204a757374206d616b65207375726520796f752061726520636f6e6e656374656420746f0a0a7468650a0a696e7465726e65742c207468656e20646f75626c652d636c69636b206f6e2074686520746173636c69656e742069636f6e20286974206d61792068617665206265656e207075740a0a6f6e20796f7572206465736b746f702c206275742069742077696c6c20646566696e6974656c7920626520696e20796f7572207374617274206d656e75292e204f6e63650a0a796f752061726520696e2074686520636c69656e74206170702c20796f752077696c6c206e65656420746f2075736520746865206f7074696f6e7320627574746f6e2061740a0a74686520746f70206f66207468652077696e646f7720746f2073657420757020616e206163636f756e742e2046726f6d2074686572652c206a75737420636c69636b207468650a0a6c6974746c6520627574746f6e20696e20746865207570706572206c6566742073656374696f6e206f66207468652073637265656e20746f20636f6e6e65637420746f207468650a0a7365727665722e20417373756d696e6720796f7572206669726577616c6c73206172656e2774206578636573736976656c7920706172616e6f69642c2069742077696c6c0a0a6d616b652061206e6f69736520616e6420796f752077696c6c2062652070757420696e746f20746865206d61696e2064697363757373696f6e206368616e6e656c2e20596f750a0a63616e207468656e2063686f6f736520612067616d652066726f6d2074686520626f74746f6d2070616e652c206f72206368617420696e2074686520746f70206f6e652e203c2f703e0a0a2020202020203c61206e616d653d22535445505f353a5f486f7374696e675f4f6e6c696e655f2d5f544153436c69656e742e657865223e3c2f613e0a0a2020202020203c68333e5354455020353a20486f7374696e67204f6e6c696e65202d20544153436c69656e742e6578653c2f68333e0a0a2020202020203c703e496e206f7264657220746f20686f737420612067616d652c20796f75206d757374206f70656e207468652022426174746c652057696e646f77222062790a0a636c69636b696e67206f6e207468652022426174746c652053637265656e2220627574746f6e2e204f6e63652074686572652c20796f752077696c6c206e65656420746f0a0a636c69636b206f6e207468652022486f737420626174746c652220627574746f6e2e20546865206261722061742074686520746f7020646566696e6573207468650a0a616d6d6f756e74206f6620706c617965727320796f752063616e20686176652028322d3136292c206e657874206973207468652067616d652773206e616d652c0a0a666f6c6c6f77656420627920612064726f70646f776e20626f7820776974682061206c697374206f6620796f75722063757272656e746c7920696e7374616c6c65640a0a6d6f64732c2074686520706f727420746865207365727665722077696c6c20686f7374206f6e2c20616e6420696620796f75207769736820746f206c6f636b20796f75720a0a7365727665722066726f6d206f75747369646572732d20796f752063616e20616c736f2061646420612070617373776f72642e203c2f703e0a0a2020202020203c703e596f75277665207374617274656420796f75722067616d652c2070656f706c65206a6f696e65642c20616e6420796f752073746172746564206974210a0a477265617421204275742c2077686174206966206f6e636520796f7527726520696e67616d652c2065766572796f6e6520656c73657327206e616d652069732073746179730a0a72656420666f72207365766572616c206d696e733f2054686174206d65616e732074686579207765726520756e61626c6520746f20636f6e6e65637420746f20796f75720a0a67616d652e20286f68206e6f6573292054686973206e6f726d616c6c79206d65616e7320796f7520686176652061206669726577616c6c20626c6f636b696e67206163636573730a0a746f20796f757220636f6d70757465722066726f6d20746865206f7574736964652e20436f6e73756c74203c610a0a20687265663d22687474703a2f2f7777772e706f7274666f72776172642e636f6d2f726f75746572732e68746d2220636c6173733d2265787465726e616c220a0a2072656c3d226e6f666f6c6c6f77223e687474703a2f2f7777772e706f7274666f72776172642e636f6d2f726f75746572732e68746d3c2f613e0a0a696620796f75206e65656420746f206b6e6f7720686f7720746f206f70656e20706f727473206f6e20796f757220726f757465722e2043686f6f736520616e792067616d650a0a696e20746865206c6973742c20697420646f65736e2774206d61747465722c206a757374206265207375726520746f207573652074686520706f727420383234352c0a0a696e7374656164206f662077686174207468652067616d652773206c697374696e67207361797320746f207573652e203c2f703e0a0a3c212d2d20536176656420696e207061727365722063616368652077697468206b657920737072696e673a7063616368653a6964686173683a313032362d312131213021312130213121302121656e20616e642074696d657374616d70203230303531303231303334363238202d2d3e0a0a2020202020203c64697620636c6173733d227072696e74666f6f746572223e0a0a2020202020203c703e5265747269657665642066726f6d20223c610a0a20687265663d22687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f77696b692f47657474696e675f53746172746564223e687474703a2f2f7461737072696e672e636c616e2d73792e636f6d2f77696b692f47657474696e675f537461727465643c2f613e223c2f703e0a0a2020202020203c2f6469763e0a0a2020202020203c2f6469763e0a0a2020202020203c2f6469763e0a0a2020202020203c2f74643e0a0a202020203c2f74723e0a0a20203c2f74626f64793e0a0a3c2f7461626c653e0a0a3c2f626f64793e0a0a3c2f68746d6c3e, 0x7574662d38),
(4, 0x3c6269673e2727274d6564696157696b6920686173206265656e207375636365737366756c6c7920696e7374616c6c65642e2727273c2f6269673e0a0a436f6e73756c7420746865205b687474703a2f2f6d6574612e77696b696d656469612e6f72672f77696b692f48656c703a436f6e74656e7473205573657227732047756964655d20666f7220696e666f726d6174696f6e206f6e207573696e67207468652077696b6920736f6674776172652e0a0a3d3d2047657474696e672073746172746564203d3d0a0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a436f6e66696775726174696f6e5f73657474696e677320436f6e66696775726174696f6e2073657474696e6773206c6973745d0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a464151204d6564696157696b69204641515d0a2a205b687474703a2f2f6d61696c2e77696b696d656469612e6f72672f6d61696c6d616e2f6c697374696e666f2f6d6564696177696b692d616e6e6f756e6365204d6564696157696b692072656c65617365206d61696c696e67206c6973745d0a0a7465737420746573742074657374, 0x7574662d38),
(5, 0x3c6269673e2727274d6564696157696b6920686173206265656e207375636365737366756c6c7920696e7374616c6c65642e2727273c2f6269673e0a0a436f6e73756c7420746865205b687474703a2f2f6d6574612e77696b696d656469612e6f72672f77696b692f48656c703a436f6e74656e7473205573657227732047756964655d20666f7220696e666f726d6174696f6e206f6e207573696e67207468652077696b6920736f6674776172652e0a0a3d3d2047657474696e672073746172746564203d3d0a0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a436f6e66696775726174696f6e5f73657474696e677320436f6e66696775726174696f6e2073657474696e6773206c6973745d0a2a205b687474703a2f2f7777772e6d6564696177696b692e6f72672f77696b692f48656c703a464151204d6564696157696b69204641515d0a2a205b687474703a2f2f6d61696c2e77696b696d656469612e6f72672f6d61696c6d616e2f6c697374696e666f2f6d6564696177696b692d616e6e6f756e6365204d6564696157696b692072656c65617365206d61696c696e67206c6973745d, 0x7574662d38);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_trackbacks`
-- 

CREATE TABLE IF NOT EXISTS `wiki_trackbacks` (
  `tb_id` int(11) NOT NULL auto_increment,
  `tb_page` int(11) default NULL,
  `tb_title` varchar(255) NOT NULL,
  `tb_url` varchar(255) NOT NULL,
  `tb_ex` text,
  `tb_name` varchar(255) default NULL,
  PRIMARY KEY  (`tb_id`),
  KEY `tb_page` (`tb_page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_trackbacks`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_transcache`
-- 

CREATE TABLE IF NOT EXISTS `wiki_transcache` (
  `tc_url` varchar(255) NOT NULL,
  `tc_contents` text,
  `tc_time` int(11) NOT NULL,
  UNIQUE KEY `tc_url_idx` (`tc_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_transcache`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_user`
-- 

CREATE TABLE IF NOT EXISTS `wiki_user` (
  `user_id` int(5) unsigned NOT NULL auto_increment,
  `user_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `user_real_name` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `user_password` tinyblob NOT NULL,
  `user_newpassword` tinyblob NOT NULL,
  `user_newpass_time` char(14) character set utf8 collate utf8_bin default NULL,
  `user_email` tinytext NOT NULL,
  `user_options` blob NOT NULL,
  `user_touched` char(14) character set utf8 collate utf8_bin NOT NULL default '',
  `user_token` char(32) character set utf8 collate utf8_bin NOT NULL default '',
  `user_email_authenticated` char(14) character set utf8 collate utf8_bin default NULL,
  `user_email_token` char(32) character set utf8 collate utf8_bin default NULL,
  `user_email_token_expires` char(14) character set utf8 collate utf8_bin default NULL,
  `user_registration` char(14) character set utf8 collate utf8_bin default NULL,
  `user_editcount` int(11) default NULL,
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  KEY `user_email_token` (`user_email_token`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_user`
-- 

INSERT INTO `wiki_user` (`user_id`, `user_name`, `user_real_name`, `user_password`, `user_newpassword`, `user_newpass_time`, `user_email`, `user_options`, `user_touched`, `user_token`, `user_email_authenticated`, `user_email_token`, `user_email_token_expires`, `user_registration`, `user_editcount`) VALUES 
(1, 0x57696b695379736f70, '', 0x434f52525550540a, '', NULL, '', 0x717569636b6261723d310a756e6465726c696e653d320a636f6c733d38300a726f77733d32350a7365617263686c696d69743d32300a636f6e746578746c696e65733d350a636f6e7465787463686172733d35300a736b696e3d0a6d6174683d310a7263646179733d370a72636c696d69743d35300a776c6c696d69743d3235300a686967686c6967687462726f6b656e3d310a737475627468726573686f6c643d300a707265766965776f6e746f703d310a6564697473656374696f6e3d310a6564697473656374696f6e6f6e7269676874636c69636b3d300a73686f77746f633d310a73686f77746f6f6c6261723d310a646174653d64656661756c740a696d61676573697a653d320a7468756d6273697a653d320a72656d656d62657270617373776f72643d300a656e6f74696677617463686c69737470616765733d300a656e6f7469667573657274616c6b70616765733d310a656e6f7469666d696e6f7265646974733d300a656e6f74696672657665616c616464723d300a73686f776e756d626572737761746368696e673d310a66616e63797369673d300a65787465726e616c656469746f723d300a65787465726e616c646966663d300a73686f776a756d706c696e6b733d310a6e756d62657268656164696e67733d300a7573656c697665707265766965773d300a77617463686c697374646179733d330a76617269616e743d656e0a6c616e67756167653d656e0a7365617263684e73303d31, 0x3230303730363034313233373433, 0x6530383138326230633539663836623831373464393364326565356536326330, NULL, NULL, NULL, 0x3230303730363034313233373338, 0),
(2, 0x5573657231, 0x5573657231, 0x6161313931316430313862353537623066303031336664366238653764646562, '', NULL, 'tim.blokdijk@desleutel.nl', 0x717569636b6261723d310a756e6465726c696e653d320a636f6c733d38300a726f77733d32350a7365617263686c696d69743d32300a636f6e746578746c696e65733d350a636f6e7465787463686172733d35300a736b696e3d0a6d6174683d310a7263646179733d370a72636c696d69743d35300a776c6c696d69743d3235300a686967686c6967687462726f6b656e3d310a737475627468726573686f6c643d300a707265766965776f6e746f703d310a6564697473656374696f6e3d310a6564697473656374696f6e6f6e7269676874636c69636b3d300a73686f77746f633d310a73686f77746f6f6c6261723d310a646174653d64656661756c740a696d61676573697a653d320a7468756d6273697a653d320a72656d656d62657270617373776f72643d300a656e6f74696677617463686c69737470616765733d300a656e6f7469667573657274616c6b70616765733d310a656e6f7469666d696e6f7265646974733d300a656e6f74696672657665616c616464723d300a73686f776e756d626572737761746368696e673d310a66616e63797369673d300a65787465726e616c656469746f723d300a65787465726e616c646966663d300a73686f776a756d706c696e6b733d310a6e756d62657268656164696e67733d300a7573656c697665707265766965773d300a77617463686c697374646179733d330a76617269616e743d656e0a6c616e67756167653d656e0a7365617263684e73303d31, 0x3230303730383238313533343033, 0x6262303538396333646432656435336262656265376335373536616363356565, NULL, 0x3535326364376639666265323666353135656334313763333666393863333830, 0x3230303730393034313533333234, 0x3230303730383238313533333234, 1);

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_user_groups`
-- 

CREATE TABLE IF NOT EXISTS `wiki_user_groups` (
  `ug_user` int(5) unsigned NOT NULL default '0',
  `ug_group` char(16) NOT NULL default '',
  PRIMARY KEY  (`ug_user`,`ug_group`),
  KEY `ug_group` (`ug_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_user_groups`
-- 

INSERT INTO `wiki_user_groups` (`ug_user`, `ug_group`) VALUES 
(1, 'bureaucrat'),
(1, 'sysop');

-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_user_newtalk`
-- 

CREATE TABLE IF NOT EXISTS `wiki_user_newtalk` (
  `user_id` int(5) NOT NULL default '0',
  `user_ip` varchar(40) NOT NULL default '',
  KEY `user_id` (`user_id`),
  KEY `user_ip` (`user_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_user_newtalk`
-- 


-- --------------------------------------------------------

-- 
-- Tabel structuur voor tabel `wiki_watchlist`
-- 

CREATE TABLE IF NOT EXISTS `wiki_watchlist` (
  `wl_user` int(5) unsigned NOT NULL,
  `wl_namespace` int(11) NOT NULL default '0',
  `wl_title` varchar(255) character set utf8 collate utf8_bin NOT NULL default '',
  `wl_notificationtimestamp` varchar(14) character set utf8 collate utf8_bin default NULL,
  UNIQUE KEY `wl_user` (`wl_user`,`wl_namespace`,`wl_title`),
  KEY `namespace_title` (`wl_namespace`,`wl_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- Gegevens worden uitgevoerd voor tabel `wiki_watchlist`
-- 


