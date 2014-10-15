<DIV ID="site">
	<DIV ID="container" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

				<DIV CLASS="row">
					<DIV ID="news_intro_cel" CLASS="cel">
						<DIV ID="news_intro_title"><?= $text[news_intro_title] ?></DIV>
						<P ID="news_intro_text"><?= $text[news_intro_text] ?></P>
					</DIV>
				</DIV>
				<DIV CLASS="row">
					<DIV CLASS="col">
						<DIV ID="comn_cel" CLASS="l_cel">
							<DIV ID="com_news_title"><?= $text[com_news_title] ?> <SPAN ID="com_news_in_english"><?= $text[com_news_in_english] ?></SPAN></DIV>

<?php
/* !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD */

	//Get a bbcode parser as $bbcode
	include_once("include/bbcode.inc.php");
	include_once("include/bbcodesetup.php");

  $sql = "";
  $sql .= "SELECT t.topic_id, topic_poster, pt.post_text, u.username, u.user_email, t.topic_time, t.topic_replies, t.topic_title ";
  $sql .= "FROM phpbb_topics AS t, phpbb_users AS u, phpbb_posts AS p, phpbb_posts_text AS pt ";
  $sql .= "WHERE t.forum_id = 2 AND t.topic_poster = u.user_id AND t.topic_id = p.topic_id AND t.topic_time = p.post_time AND pt.post_id = p.post_id ";
  $sql .= "ORDER  BY t.topic_time DESC ";
  $sql .= "LIMIT 10";

  $res = mysql_query($sql);

  //Count the rows
  for ($i = 0; ; $i++) {

/*
	if ($i > 0)
	{
		break;
	}
*/

    //Try to get the next item
    $row = mysql_fetch_assoc($res);
    if ($row == "")
    	break;

    //Print a divider
    if ($i > 0) {
      echo "<BR>\n";
    }

    //Retrieve the fields to variables
    $id = $row['topic_id'];
    $poster = $row['topic_poster'];
    $time = $row['topic_time'];
    $numcomm = $row['topic_replies'];
    $title = $row['topic_title'];
    $username = $row['username'];
    $usermail = $row['user_email'];
    $news_text = $row['post_text'];

    //Do extra parsing
    $news_text = $bbcode->parse($news_text);
    $time = date("Y-m-d H:i", $time);

    print("<b>".$title."</b><br>");
    print($news_text);
    print("<br><BR>");

    print('<font size="-2">');
    print("Posted by ".$username." at ".$time.", ");
    print('<a href="/messageboard/viewtopic.php?t=' . $id . '"><font size="-2">');
    print("$numcomm comment");
    if ($numcomm != 1)
    	print("s");
    print('</font></a>');
    print('</font><br><br>');

  }

/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */


?>
<!--
							<P><B>New Kernel Panic release</B><BR>Version 1.5, expanded build options and a new &uuml;ber unit the &quot;MAINFRAME&quot; watch out for those terminals!<BR>Get it HERE</P>
							<P><B>Complete Obliteration version 0.75b</B><BR>Just a quick bug-fix release as the &quot;Flamero&quot; had a crash bug in the canister loader script.<BR>Download it at X</P>
							<P><B>Sometimes all I need is a little text filler to get the message across.</B><BR>Just when I was thinking I had enought text to simulate a real news section...<BR> Well, guess what.. I came to the conclusion that I did not have enough.</P>
-->
						</DIV>
					</DIV>

					<DIV CLASS="col">
						<DIV ID="pron_cel" CLASS="r_cel">
							<DIV ID="pro_news_title"><?= $text[pro_news_title] ?> <SPAN ID="pro_news_in_english"><?= $text[pro_news_in_english] ?></SPAN></DIV>

<?php
/* !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD !!! WARNING !!! CUT AND PASTE CODE AHEAD */

	//Get a bbcode parser as $bbcode
	include_once("include/bbcode.inc.php");
	include_once("include/bbcodesetup.php");

  $sql = "";
  $sql .= "SELECT t.topic_id, topic_poster, pt.post_text, u.username, u.user_email, t.topic_time, t.topic_replies, t.topic_title ";
  $sql .= "FROM phpbb_topics AS t, phpbb_users AS u, phpbb_posts AS p, phpbb_posts_text AS pt ";
  $sql .= "WHERE t.forum_id = 2 AND t.topic_poster = u.user_id AND t.topic_id = p.topic_id AND t.topic_time = p.post_time AND pt.post_id = p.post_id ";
  $sql .= "ORDER  BY t.topic_time DESC ";
  $sql .= "LIMIT 10";

  $res = mysql_query($sql);

  //Count the rows
  for ($i = 0; ; $i++) {

/*
	if ($i > 0)
	{
		break;
	}
*/

    //Try to get the next item
    $row = mysql_fetch_assoc($res);
    if ($row == "")
    	break;

    //Print a divider
    if ($i > 0) {
      echo "<BR>\n";
    }

    //Retrieve the fields to variables
    $id = $row['topic_id'];
    $poster = $row['topic_poster'];
    $time = $row['topic_time'];
    $numcomm = $row['topic_replies'];
    $title = $row['topic_title'];
    $username = $row['username'];
    $usermail = $row['user_email'];
    $news_text = $row['post_text'];

    //Do extra parsing
    $news_text = $bbcode->parse($news_text);
    $time = date("Y-m-d H:i", $time);

    print("<b>".$title."</b><br>");
    print($news_text);
    print("<br><BR>");

    print('<font size="-2">');
    print("Posted by ".$username." at ".$time.", ");
    print('<a href="/messageboard/viewtopic.php?t=' . $id . '"><font size="-2">');
    print("$numcomm comment");
    if ($numcomm != 1)
    	print("s");
    print('</font></a>');
    print('</font><br><br>');

  }

/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */


?>
<!--
							<P><B>Spring has two new domains!</B><BR> springrts.com and springrts.org</P>
							<P><B>Tobi takes on the lead developer role.</B><BR>Tobi is going to take us to to 1.0!<BR> We thank Yaha for his work on the 0.74 releases.</P>
							<P><B>I think three items (total of 6) for the news section is right.</B><BR>More would make it a wall of text and two is a little slim to get a good idea of recent developments.<BR>But it's open for discussion..? Two might actualy be better now that I'm seeing the result of my typing work.</P>
-->
						</DIV>
					</DIV>

					<DIV CLASS="clear"></DIV>

				</DIV>

			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>
