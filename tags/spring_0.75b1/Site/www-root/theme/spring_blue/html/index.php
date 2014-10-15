<DIV ID="site">
	<DIV ID="cont1" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">
				<DIV ID="row1" CLASS="row">
					<DIV CLASS="col">
						<DIV ID="down_cel" CLASS="l_cel">
							<DIV ID="download_title"><?= $text[download_title] ?></DIV>
							<P ID="download_text"><?= $text[download_text] ?></P>
						</DIV>
					</DIV>
					<DIV CLASS="col">
						<DIV ID="high_cel" CLASS="r_cel">
							<DIV ID="highlight_title"><?= $text[highlight_title] ?> <SPAN ID="highlight_in_english"><?= $text[highlight_in_english] ?></SPAN></DIV>

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

	if ($i > 0)
	{
		break;
	}

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

//    print("<b>$title</b><br>");
    print("<P ID=\"highlight_text\">".$news_text."</P>");
//    print("<br>");

/*    print('<font size="-2">');
    print("Posted by " . hidemail($usermail, $username, -2) . " at $time, ");
    print('<a href="/phpbb/viewtopic.php?t=' . $id . '"><font size="-2">');
    print("$numcomm comment");
    if ($numcomm != 1)
    	print("s");
    print('</font></a>');
    print('</font><br><br>');
*/
  }

/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */


?>


<!--
							<P ID="highlight_text">I would like to thank <A HREF="http://en.wikipedia.org/wiki/Chris_Taylor_(game_designer)">Chris Taylor</A> of <A HREF="http://www.gaspowered.com/">GPG</A> for that great game "Total Annihilation".</P>
-->
						</DIV>
					</DIV>
					<DIV CLASS="clear"></DIV>
				</DIV>

				<DIV ID="row2" CLASS="row">
					<DIV ID="into_cel"  CLASS="cel">
						<DIV ID="introduction_title"><?= $text[introduction_title] ?></DIV>
						<P ID="introduction_text"><?= $text[introduction_text] ?><P>
					</DIV>
				</DIV>

				<DIV ID="row3" CLASS="row">
					<DIV CLASS="col">
						<DIV ID="feat_cel" CLASS="l_cel">
							<DIV> <!-- This DIV is here to save IE6 from hanging as it chokes on l_cel's "padding: 10px;" once JavaScript appendChild's a flash video. -->
								<DIV ID="features_title"><?= $text[features_title] ?></DIV>
								
								<P ID="features_text"><?= $text[features_text] ?></P>

								<DIV ID="features_list">
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature1] ?></DIV>
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature2] ?></DIV>
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature3] ?></DIV>
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature4] ?></DIV>
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature5] ?></DIV>
									<DIV CLASS="feature_item">&nbsp;&rarr;&nbsp;<?= $text[feature6] ?></DIV>
								</DIV>
							</DIV>
						</DIV>
					</DIV>

					<DIV CLASS="col">
						<DIV ID="info_cel" CLASS="r_cel">
							<DIV ID="info_title"><?= $text[info_title] ?></DIV>	

							<P ID="info_text1"><?= $text[info_text1] ?></P>
							
							<UL>
								<LI><A HREF="wiki/getting started"><?= $text[info_getting_strated] ?></A></LI>
								<LI><A HREF="wiki/player guide"><?= $text[info_player_guide] ?></A></LI>
							</UL>
							
							<P ID="info_text2"><?= $text[info_text2] ?></P>
						
							<UL>
								<LI><A HREF="news"><?= $text[info_news] ?></A></LI>
								<!-- <LI><A HREF="reviews">Community Reviews</A></LI> Disabled for now -->
								<LI><A HREF="messageboard"><?= $text[info_messageboard] ?></A></LI>
								<LI><A HREF="wiki"><?= $text[info_wiki] ?></A></LI>
								<LI><A HREF="http://www.spring-league.com"><?= $text[info_league] ?></A></LI>
							</UL>
						</DIV>
					</DIV>

					<DIV CLASS="clear"></DIV>
				</DIV>

			</DIV>
		</DIV>


		<DIV ID="scsh_col" CLASS="edge">
			<DIV CLASS="back">
				<DIV ID="scsh_cel" CLASS="cel">
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen0.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen0.jpg" TITLE="Spring Screenshot - Click for a larger version"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen1.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen1.jpg" TITLE="Spring Screenshot - Click for a larger version"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen2.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen2.jpg" TITLE="Spring Screenshot - Click for a larger version"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen3.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen3.jpg" TITLE="Spring Screenshot - Click for a larger version"></A>
				</DIV>
				<DIV ID="more_cel" CLASS="cel">
					<A HREF="/wiki/screenshots"><?= $text[screenshots_more] ?></A>
				</DIV>
			</DIV>
		</DIV>

	</DIV>

	<DIV ID="cont2" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

				<DIV ID="row4" CLASS="row">
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

	if ($i > 2)
	{
		break;
	}

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

    print("<b>$title</b><br>");
    print($news_text);
    print("<br>");

/*    print('<font size="-2">');
    print("Posted by " . hidemail($usermail, $username, -2) . " at $time, ");
    print('<a href="/phpbb/viewtopic.php?t=' . $id . '"><font size="-2">');
    print("$numcomm comment");
    if ($numcomm != 1)
    	print("s");
    print('</font></a>');
    print('</font><br><br>');
*/
  }

/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */


?>

<!--
This is wat I would like to generate with the above code..

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

	if ($i > 2)
	{
		break;
	}

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

    print("<b>$title</b><br>");
    print($news_text);
    print("<br>");

/*    print('<font size="-2">');
    print("Posted by " . hidemail($usermail, $username, -2) . " at $time, ");
    print('<a href="/phpbb/viewtopic.php?t=' . $id . '"><font size="-2">');
    print("$numcomm comment");
    if ($numcomm != 1)
    	print("s");
    print('</font></a>');
    print('</font><br><br>');
*/
  }

/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */
/* I riped this from the original site, I just need the site to funtion... this all should be just a call to a nice PHPBB reader function/class. :-( */
/* !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE !!! WARNING !!! CUT AND PASTE CODE ABOVE */


?>

<!--
This is wat I would like to generate with the above code..

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

