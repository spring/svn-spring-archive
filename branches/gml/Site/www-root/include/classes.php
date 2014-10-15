<?php

/* FIXME!! This is to be replaced with the site_theme class ($_SESSION[theme]) */
$site_theme = 'spring_blue';


if($_GET[disable_css])
{
	$css = FALSE;
}
else
{
	$css = TRUE;
}


if($_GET[disable_javascript])
{
	$javascript = FALSE;
}
else
{
	$javascript = TRUE;
}

class site_language
{

/* This class is split up in three parts, the set_session_language and map_language method below is section one.
** The methods following that are for storing language data in the database (section two).
** The methods for retreving the data from the database can be found found after that (section three).
*/

	function set_session_language()
	{
		global $site_configuration;

		// First we look if a language is selected by the user.
		if (isset($_GET[language]))
		{
			// User selected a language.
			if(self::check_language_available($_GET[language]))
			{
				// Language exsists in the database.
				$_SESSION['language'] = $_GET[language];
			}
		}
		// If not then we look if a language is set in the session.
		elseif (isset($_SESSION['language']))
		{
			// It exsists. All is cool.
		}
		// If both fail we detect the language from the browser settings.
		elseif (isset($_SERVER['HTTP_ACCEPT_LANGUAGE']))
		{
			$languages = explode(",", $_SERVER['HTTP_ACCEPT_LANGUAGE']);
			foreach($languages as $lang)
			{
				$lang_tmp = explode(";q=", trim($lang));
				$lang = trim($lang_tmp[0]);
				if(isset($lang_tmp[1]))
				{
					$importance = trim($lang_tmp[1]);
				}
				else
				{
					$importance = 1;
				}
				$language_array["$lang"] = (float)$importance;
		    }
			// print_r($language_array);
		    arsort($language_array); // You end up with a array of languages and there importance, first language in array is most important.

		    foreach($language_array as $lang => $importance)
			{
				$tmp = self::map_language($lang);
				if(self::check_language_available($tmp))
				{
					$_SESSION['language'] = $tmp;
				}
		    }
		}
		// If we can't get it from the browser we do a fallback to the default language.
		else
		{
			$_SESSION['language'] = $site_configuration[language][default_language];
		}
	}

	private static function map_language($language_browser)
	{
		global $site_configuration;

		while (list($language) = each($site_configuration[language][map]))
		{
			if(in_array($language_browser, $site_configuration[language][map][$language]))
			{
				return $language;
			}
		}
	}


/* The following methods are for storing language data in the database.
** You need to make a site_languge object before you can use these methods.
** The methods for retreving the data from the database can be found found after this.
*/

	private $text = FALSE;
	private $section = FALSE;
	private $language = FALSE;
	private $user = FALSE;
	private $major = FALSE;
	private $minor = FALSE;

	public function set_text($text)
	{
		// FIXME!! Need to check if it's a array and other stuff.
		$this->text = $text;
	}

	public function set_section($section)
	{
		// FIXME!! Need to check if section exists in database.
		$this->section = $section;
	}

	public function set_language($language)
	{
		// FIXME!! Need to check if language exists in database.
		$this->language = $language;
	}

	public function set_user($user, $password)
	{
		// FIXME!! Need to check if user exists in phpbb database with this password, then set $this->user to user ID not login-name.
		$this->user = $user;
	}

	public function set_major($major)
	{
		$this->major = $major;
	}

	public function set_minor($minor)
	{
		$this->minor = $minor;
	}

	public function save_text()
	{
		global $spring_db;

		if ($this->text && $this->section && $this->language && $this->user && $this->major !== FALSE && $this->minor !== FALSE)
		{
			// FIXME!! check if major is equal or more then major in db for section/language.
			// FIXME!! if major is equal to major in database check if minor is more then larger in db for section/language.
			// FIXME!! Also need to filter "script" "iframe" "frameset" "extra_key_" "extra_value" more?

			$start_end[0] = "=STR%\"";
			$start_end[1] = "\"&END%";
			foreach ($this->text as $key => $value)
			{
				$key = str_replace ($start_end, "", $key); // Remove any =STR%" and "END% from the key.
				$value = str_replace ($start_end, "", $value); // Remove any =STR%" and "END% from the value.
				$text .= $key.$start_end[0].$value.$start_end[1];
			}

			// Prevent sql injection
			$section = $spring_db->escape_string($this->section);
			$language = $spring_db->escape_string($this->language);
			$user = $spring_db->escape_string($this->user);
			$major = $spring_db->escape_string($this->major);
			$minor = $spring_db->escape_string($this->minor);
			$text = $spring_db->escape_string($text);

			// All is fine I guess, let's safe it to permenent storage.
			$sql =	"
			INSERT INTO `site_language`
				(`language`, `user`, `date_time`, `version_major`, `version_minor`, `".$section."`)
			VALUES
				('".$language."', '".$user."', NOW(), '".$major."', '".$minor."', '".$text."')";

			$spring_db->query($sql) or die("ERROR (SQL Query): " . $spring_db->error);
		}
		else
		{
			die('Error: Not all required parameters to the save method in the langauage class are provided. I hope you did not lose hours of translation work... :-( (TIP: PRESS BACK ON YOUR BROWSER)');
		}
	}

	public static function version($section = FALSE, $language = FALSE)
	{
		/*
		If first argument is missing - error out, if second argument is missing - error out.
		Return the most recent version number of the requested section and language.
		*/

		// Is $section set.
		if(!$section)
		{
			die('ERROR: $section variable missing with version() method.'); // We have to know what section needs to be retrieved.
		}

		// Is $langage set?
		if(!$language)
		{
			die('ERROR: $language variable missing with version() method.'); // We have to know what language version needs to be retrieved.
		}
		
		// Now that $language and $section are OK we can check if they are available. And if so load in the text.
		if (!self::check_section_available($section))
		{
			die('ERROR: $section not available (not in database).'); // Can't find the section...
		}

		if (self::check_language_available_for_section($section, $language))
		{
			$version = self::get_version($section, $language);
		}
		else
		{
			die('ERROR: $language not available (not in database) for $section.'); // Can't find it.
		}

		return $version;
	}

	private static function get_version($section, $language)
	{
		global $spring_db;

		// SQL query to get the most recent version of $section in $language.
		$section = $spring_db->escape_string($section);
		$language = $spring_db->escape_string($language);

		$sql = "
		SELECT
			`version_major` AS major, `version_minor` AS minor
		FROM
			`site_language`
		WHERE
			`language` = '".$language."'
		AND
			`".$section."` IS NOT NULL
		AND
			`version_minor` =
			(
			SELECT
				MAX(`version_minor`)
			FROM
				`site_language`
			WHERE
				`language` = '".$language."'
			AND
				`".$section."` IS NOT NULL
			AND
				`version_major` =
				(
				SELECT
					MAX(`version_major`)
				FROM
					`site_language`
				WHERE
					`language` = '".$language."'
				AND
					`".$section."` IS NOT NULL
				)
			)
		ORDER BY
			`id` DESC
		LIMIT 1;
		";

		$result = $spring_db->query($sql) or die("ERROR (SQL Query): " . $spring_db->error);
		$version = $result->fetch_array();

		return $version; // Give back the language text array.
	}

	public static function available_sections()
	{
		global $spring_db;

		$result = $spring_db->query("SHOW COLUMNS FROM site_language") or die("ERROR (SQL Query): " . $spring_db->error);
		while(!is_null($row = $result->fetch_array(MYSQLI_ASSOC)))
		{
			if ($row[Type] == 'text')
			{
				$sections[] = $row[Field];
			}
		}

		return $sections; // Give back an array with the sections that are available. 
	}

	public static function available_languages($exclude_array)
	{
		global $spring_db;

		$result = $spring_db->query("SELECT DISTINCT `language`, `native_name` FROM `site_language` WHERE `native_name` IS NOT NULL") or die("ERROR (SQL Query): " . $spring_db->error);
		while(!is_null($row = $result->fetch_array(MYSQLI_ASSOC)))
		{
			if (!in_array($row[language], $exclude_array))
			{
				$languages[$row[language]] = $row[native_name];
			}
		}
		return $languages; // Give back a array that with the available languages in the database (in the keys), minus the $exclude_array languages and with the native name of the language. (in the values)
	}

/* The following methods are for retriving data from the database.
*/

	public static function get_page()
	{
		global $site_configuration;
		global $page_name;
		global $site_theme; // Should work via $_SESSION[theme]..
		global $javascript;
		global $css;

		$text = self::text('header', $_SESSION[language]);
		array_walk($text, array(self, clean_text));
		include_once("theme/".$_SESSION[theme]."/html/page_header.php");

		$text = self::text($page_name, $_SESSION[language]);
		array_walk($text, array(self, clean_text));
		include_once("theme/".$_SESSION[theme]."/html/".$page_name.".php");

		if($javascript)
		{
			echo "<SCRIPT TYPE=\"text/javascript\">\n";
			include_once("theme/".$_SESSION[theme]."/javascript/javascript.php"); // Javascript include's.
			echo "</SCRIPT>";
		}

		echo "</BODY>\n</HTML>";
	}

	public static function text($section = FALSE, $language = FALSE)
	{
		/*
		If first argument is missing - error out, if second argument is missing - default to the default language.
		Return the most recent version of the requested text section and if possible in the requsted language.
		if ($_GET[debug] == TRUE) then echo debug information.
		*/

		global $site_configuration;

		// Is $section set.
		if(!$section)
		{
			die('ERROR: $section variable missing with text() method.'); // We have to know what section needs to be retrieved.
		}

		// Is $langage set?
		if(!$language)
		{
			$language = $site_configuration[language][default_language]; // No specific language requested, default to the default language.
		}
		
		// Now that $language and $section are OK we can check if they are available. And if so load in the text.
		if (!self::check_section_available($section))
		{
			die('ERROR: $section not available (not in database).'); // Can't find the section...
		}

		if (self::check_language_available_for_section($section, $language))
		{
			$text = self::get_text($section, $language);
			$available = 'Yes!'; // For debugging.
		}
		else
		{
			$text = self::get_text($section, $site_configuration[language][default_language]);
			$available = 'No! - using "'.$site_configuration[language][default_language].'" (default).'; // For debugging.
		}

		// Debug information! Alway's nice to have this laying around when you need it.
		// JavaScript injection should not be a problem here as long as $_GET it's not going into or coming from persistent storage! (without being checked).
		// Beware of usring something like print_r on $site_configuration here as it contains sensetive data.
		if ($_GET[debug] == TRUE)
		{
			echo "<DIV CLASS=\"language_debug\">\n";
			echo "<PRE>\n";
			echo "===================================== <B>Start of language debug</B> =====================================\n\n";
			echo "<B>Language request from: \"".$_SERVER['PHP_SELF']."\"</B>\n\n";

			echo "<B>\$_GET</B>\n";
			print_r($_GET);

			echo "\n<B>\$section</B>\n";
			echo $section."\n";

			echo "\n<B>\$language</B>\n";
			echo $language."\n";
			echo 'Is this language used? <B>'.$available."</B>\n\n";

			echo "<B>\$text</B>\n";
			print_r($text);
			echo "===================================== <B>End of language debug</B> =====================================\n\n";
			echo "</PRE>\n";
			echo "</DIV>";
		}
		return $text;
	}

	private static function get_text($section, $language)
	{
		global $spring_db;

		// SQL query to get the most recent version number of $section in $language.
		$section = $spring_db->escape_string($section);
		$language = $spring_db->escape_string($language);

		$sql = "
		SELECT
			`".$section."`
		FROM
			`site_language`
		WHERE
			`language` = '".$language."'
		AND
			`".$section."` IS NOT NULL
		AND
			`version_minor` =
			(
			SELECT
				MAX(`version_minor`)
			FROM
				`site_language`
			WHERE
				`language` = '".$language."'
			AND
				`".$section."` IS NOT NULL
			AND
				`version_major` =
				(
				SELECT
					MAX(`version_major`)
				FROM
					`site_language`
				WHERE
					`language` = '".$language."'
				AND
					`".$section."` IS NOT NULL
				)
			)
		ORDER BY
			`id` DESC
		LIMIT 1;
		";

		$page_text = $spring_db->query($sql) or die("ERROR (SQL Query): " . $spring_db->error);

		// Make a nice $text array with the result from the above query.
		$page_text = $page_text->fetch_array(MYSQLI_NUM);
		$page_text = explode("\"&END%", $page_text[0]);
		foreach($page_text as $tmp)
		{
			$tmp = explode("=STR%\"",trim($tmp));
			$text[$tmp[0]] = stripslashes($tmp[1]); // An array without the slashes.
		}
		array_pop($text); // Remove the last element from the array as the explode give's us one to much.

		return $text; // Give back the language text array.
	}

	public static function clean_text(&$textval, $textkey)
	{
		$textval = htmlspecialchars($textval, ENT_QUOTES, 'UTF-8');
		$textval = str_replace(array("\r\n", "\r", "\n"), "<BR>", $textval);

		/* The following code is adapted from clericvash's "Topic Extraction PHPBB mod" (also GPL) */
		$textval = preg_replace('/\[url\](.*)\[\/url\]/Usi','<A HREF="$1">$1</A>',$textval);
		$textval = preg_replace('/\[url=(.*)\](.*)\[\/url\]/Usi','<A HREF="$1">$2</A>',$textval);
		$textval = str_replace("[b]","<B>",$textval);
		$textval = str_replace("[/b]","</B>",$textval);
		$textval = str_replace("[i]","<I>",$textval);
		$textval = str_replace("[/i]","</I>",$textval);
		$textval = str_replace("[u]","<U>",$textval);
		$textval = str_replace("[/u]","</U>",$textval);
	}

	public static function check_section_available($section)
	{
		global $spring_db;

		$section = $spring_db->escape_string($section);
		$result = $spring_db->query("SHOW COLUMNS FROM site_language LIKE '".$section."'") or die("ERROR (SQL Query): " . $spring_db->error);

		if ($result->num_rows != 1)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	public static function check_language_available($language)
	{
		global $spring_db;

		/*
		Check if $language exsists in the `site_language`.`language` field.
		*/

		$language = $spring_db->escape_string($language);
		$result = $spring_db->query("SELECT `language` FROM `site_language` WHERE `language` = '".$language."' LIMIT 1") or die("ERROR (SQL Query): " . $spring_db->error);
		if ($result->num_rows != 1)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	public static function check_language_available_for_section($section, $language)
	{
		global $spring_db;

		if (self::check_section_available($section))
		{
			// Is the requested language available for this section?
			$section = $spring_db->escape_string($section);
			$language = $spring_db->escape_string($language);
			$result = $spring_db->query("SELECT `language` FROM `site_language` WHERE `language` = '".$language."' AND `".$section."` IS NOT NULL LIMIT 1") or die("ERROR (SQL Query): " . $spring_db->error);
			if ($result->num_rows != 1)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return false;
		}
	}

}

class site_theme
{
	// FIXME!! This class needs work. About the same as set_session_language in site_language class above.

	public static function set_session_theme ()
	{
		$_SESSION['theme'] = 'spring_blue';
	}

}

class site_news
{
	public static function get_news ($forum_id, $amount, $type = 'news')
	{
		global $spring_db;
		global $bbcode;

		if (!is_int($forum_id)) { die('Error: $forum_id needs to be an int. (get_news method)'); }
		if (!is_int($amount)) { die('Error: $amount needs to be an int. (get_news method)'); }

		//Get a bbcode parser as $bbcode
		require_once("include/bbcode.inc.php");
		require_once("include/bbcodesetup.php");

		$topic = $spring_db->escape_string($topic);
		$amount = $spring_db->escape_string($amount);

		$sql = "
		SELECT
			t.topic_id, topic_poster, pt.post_text, u.username, u.user_email, t.topic_time, t.topic_replies, t.topic_title

		FROM
			phpbb_topics AS t, phpbb_users AS u, phpbb_posts AS p, phpbb_posts_text AS pt

		WHERE
			t.forum_id = ".$forum_id."
		AND
			t.topic_poster = u.user_id
		AND
			t.topic_id = p.topic_id
		AND
			t.topic_time = p.post_time
		AND
			pt.post_id = p.post_id

		ORDER BY t.topic_time DESC
		LIMIT ".$amount."
		";

		$result = $spring_db->query($sql) or die("ERROR (SQL Query): " . $spring_db->error);

		$news = FALSE;
		while(!is_null($row = $result->fetch_array(MYSQLI_ASSOC)))
		{
			$row['post_text'] = $bbcode->parse($row['post_text']);
			$row['topic_time'] = date("Y-m-d H:i", $row['topic_time']);

			if ($type == 'news' || $type == 'short')
			{
				$news .= "<B>".$row['topic_title']."</B>";
				$news .= "<BR>\n";
			}
			$news .= $row['post_text'];
			if ($type == 'news')
			{
				$news .= "<BR>\n";
				$news .= '<FONT SIZE="-1">';
				$news .= "<BR>\n";
				$news .= 'Posted by '.$row['username'].' at '.$row['topic_time'].', ';
				$news .= '<A HREF="/messageboard/viewtopic.php?t='.$row['topic_id'].'"><FONT SIZE="-1">';
				$news .= $row['topic_replies'].'comment';
				if ($row['topic_replies'] != 1) { $news .= 's'; }
				$news .= '</FONT></A>';
				$news .= '</FONT>';
				$news .= "<BR>\n";
			}
			$news .= "<BR>\n";
		}

		return $news; // Give back a html ready string.
	}
}

?>
