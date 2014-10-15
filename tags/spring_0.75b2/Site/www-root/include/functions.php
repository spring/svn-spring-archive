<?php

function get_page()
{
	global $page_name;
	global $site_theme;
	global $javascript;
	global $css;

	$text = spring_language::text('header', $_GET[language]);
	array_walk($text, 'clean_text');
	include_once("theme/".$site_theme."/html/page_header.php");

	$text = spring_language::text($page_name, $_GET[language]);
	array_walk($text, 'clean_text');
	include_once("theme/".$site_theme."/html/".$page_name.".php");

	if($javascript)
	{
		echo "<SCRIPT TYPE=\"text/javascript\">\n";
		include_once("theme/".$site_theme."/javascript/javascript.php"); // Javascript include's.
		echo "</SCRIPT>";
	}

	echo "</BODY>\n</HTML>";
}

function clean_text(&$textval, $textkey)
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

class spring_language
{
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
			$section = mysql_real_escape_string($this->section);
			$language = mysql_real_escape_string($this->language);
			$user = mysql_real_escape_string($this->user);
			$major = mysql_real_escape_string($this->major);
			$minor = mysql_real_escape_string($this->minor);
			$text = mysql_real_escape_string($text);

			// All is fine I guess, let's safe it to permenent storage.
			$sql =	"
			INSERT INTO `site_language`
				(`language`, `user`, `date_time`, `version_major`, `version_minor`, `".$section."`)
			VALUES
				('".$language."', '".$user."', NOW(), '".$major."', '".$minor."', '".$text."')";

			mysql_query($sql) or die("ERROR (SQL Query): " . mysql_error());
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

	public static function text($section = FALSE, $language = FALSE)
	{
		/*
		If first argument is missing - error out, if second argument is missing - default to English.
		Return the most recent version of the requested text section and if possible in the requsted language, otherwise default to English.
		(We presume there's alway's an up to date English text for every section.)
		if ($_GET[debug] == TRUE) then echo debug information.
		*/

		// Is $section set.
		if(!$section)
		{
			die('ERROR: $section variable missing with text() method.'); // We have to know what section needs to be retrieved.
		}

		// Is $langage set?
		if(!$language)
		{
			$language = 'english'; // No specific language requested, default to english language.
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
			$text = self::get_text($section, 'english');
			$available = 'No! - using English (default).'; // For debugging.
		}

		// Debug information! Alway's nice to have this laying around when you need it.
		// JavaScript injection should not be a problem here as long as $_GET it's not going into or coming from persistent storage! (without being checked).
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

	public static function check_section_available($section)
	{
		/*
		Check if field ($section) itself exsists in 'site_language' table.
		*/

		return true; // FIXME!!
	}

	public static function check_language_available($language)
	{
		/*
		Check if $language exsists in the `site_language`.`language` field.
		*/

		return false; // FIXME!!
	}

	public static function check_language_available_for_section($section, $language)
	{
		if (self::check_section_available($section))
		{
			// Is the requested language available for this section?
			$section = mysql_real_escape_string($section);
			$language = mysql_real_escape_string($language);
			$result = mysql_query("SELECT `language` FROM `site_language` WHERE `language` = '".$language."' AND `".$section."` IS NOT NULL LIMIT 1") or die("ERROR (SQL Query): " . mysql_error());
			if (mysql_num_rows($result) != 1)
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

	private static function get_version($section, $language)
	{
		// SQL query to get the most recent version of $section in $language.
		$section = mysql_real_escape_string($section);
		$language = mysql_real_escape_string($language);
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

		$result = mysql_query($sql) or die("ERROR (SQL Query): " . mysql_error());
		$version = mysql_fetch_array($result);

		return $version; // Give back the language text array.
	}

	private static function get_text($section, $language)
	{
		// SQL query to get the most recent version number of $section in $language.
		$section = mysql_real_escape_string($section);
		$language = mysql_real_escape_string($language);
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

/*
		$sql = "
		SELECT
			`".$section."`
		FROM
			`spring`.`site_language` 
		WHERE
			`language` = '".$language."'
		AND
			(`site_language`.`language`, `site_language`.`id`)
			IN (
			SELECT
				`site_language`.`language`, MAX(`site_language`.`id`) AS id
			FROM
				`spring`.`site_language`
			WHERE
				`site_language`.`".$section."` IS NOT NULL
			GROUP BY
				`site_language`.`language`
			)
		";
*/

		$page_text = mysql_query($sql) or die("ERROR (SQL Query): " . mysql_error());

		// Make a nice $text array with the result from the above query.
		$page_text = mysql_fetch_row($page_text);
		$page_text = explode("\"&END%", $page_text[0]);
		foreach($page_text as $tmp)
		{
			$tmp = explode("=STR%\"",trim($tmp));
			$text[$tmp[0]] = stripslashes($tmp[1]); // An array without the slashes.
		}
		array_pop($text); // Remove the last element from the array as the explode give's us one to much.

		return $text; // Give back the language text array.
	}
}

class spring_messageboard_reader
{
	// FIXME!! This class needs LOADS of work (and don't forget about a PHPBB3 migration!

	public static function news_reader ($from, $amount)
	{
		/*
		Reads $from (the news source - forum) and returns an $amount of the latest news entry's in an multidementional array.
		*/

		if ("com_news" == $from) { $forum_id = "???"; } // Still need to make a new sub-forum for this one.
		if ("pro_news" == $from) { $forum_id = 2; }

		if (!is_int($amount)) { die('Error: $amount needs to be an int. (news_reader function)'); }
		$amount = mysql_real_escape_string($amount);
		$sql .= "
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

		$res = mysql_query($sql);

		//Count the rows
		for ($i = 0; ; $i++)
		{
			//Try to get the next item
			$row = mysql_fetch_assoc($res);
			if ($row == "")
			break;

			//Print a divider
			if ($i > 0)
			{
				include("inc/hr-small.php");
			}

		//Retrieve the fields to variables
		$id = $row['topic_id'];
		$poster = $row['topic_poster'];
		$time = $row['topic_time'];
		$numcomm = $row['topic_replies'];
		$title = $row['topic_title'];
		$username = $row['username'];
		$usermail = $row['user_email'];
		$text = $row['post_text'];

		//Do extra parsing
		$text = $bbcode->parse($text);
		$time = date("Y-m-d H:i", $time);

		print("<b>$title</b><br>");
		print($text);
		print("<br><br>");
		print('<font size="-2">');
		print("Posted by " . hidemail($usermail, $username, -2) . " at $time, ");
		print('<a href="/phpbb/viewtopic.php?t=' . $id . '"><font size="-2">');
		print("$numcomm comment");
		if ($numcomm != 1)
		print("s");
		print('</font></a>');
		print('</font><br><br>');
		}

	}
}


/**/
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

?>
