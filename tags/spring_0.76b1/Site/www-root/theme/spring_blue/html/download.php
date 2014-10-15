<DIV ID="site">
	<DIV ID="container" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

<?php
/*
NOTE!!!
This page is taken from the 1.0 site and hacked up a bit to work in the 2.0 site.
Not clean or anything and more work should be done to make this better.
NOTE!!!
*/

$post_id = 2655;

//Get a bbcode parser as $bbcode
include_once("include/bbcode.inc.php");
include_once("include/bbcodesetup.php");

  // swaps two elements in an array
  function swap (&$input, $i, $j)
  {
      $temp = $input[$i];
      $input[$i]=$input[$j];
      $input[$j]=$temp;
  }  	

  $sql1 = "";
  $sql1 .= "SELECT t.topic_id, topic_poster, pt.post_text, u.username, u.user_email, t.topic_time, t.topic_replies, t.topic_title, pt.post_subject, p.post_time, p.post_edit_time ";
  $sql1 .= "FROM phpbb_topics AS t, phpbb_users AS u, phpbb_posts AS p, phpbb_posts_text AS pt ";
  $sql1 .= "WHERE t.forum_id = 4 AND t.topic_poster = u.user_id AND t.topic_id = p.topic_id AND pt.post_id = p.post_id AND t.topic_type = 0 AND t.topic_time = p.post_time ";
  $sql1 .= "ORDER BY t.topic_title DESC";

  $res1 = mysql_query($sql1);

  $colors[0] = "C8D2DA";
  $colors[1] = "BDC6CE";
  $curcolor = 0;

  // loop through all sections (starting posts) and within them loop through all posts (replies)
  while ($row1 = mysql_fetch_assoc($res1)) {

    //Retrieve the fields to variables
    $id = $row1['topic_id'];
    $post_text = $row1['post_text'];
    $title = $row1['post_subject'];

    //Do extra parsing
    $post_text = $bbcode->parse($post_text);

?>
				<DIV CLASS="row">
					<DIV ID="download1" CLASS="cel">
						<DIV ID="download1_title"><?= substr($title, 1) ?></DIV>
<?php


//    print('<div style="font-size: 12px;"><b>' . substr($title, 1) . '</b></div><br>');
echo "<HR>";
    print($post_text);
    print('<br><br>');
		print('<table width="100%" border="0" cellpadding="4" cellspacing="0">');
		print('<tr valign="top"><td width="25%"><b>File information</b></td><td width="43%"><b>Description</b></td><td width="32%"><b>Download links</b></td></tr>');
		print('<tr><td colspan="3"><img src="/res/hrsmall.gif" height="2" width="730"></td></tr>');

    // now lets iterate through all of the replies:
    $sql2 = "";
    $sql2 .= "SELECT t.topic_id, topic_poster, pt.post_text, u.username, u.user_email, t.topic_time, t.topic_replies, t.topic_title, pt.post_subject, p.post_time, p.post_edit_time, if(t.topic_time=p.post_time, 1, 0) as first_post ";
    $sql2 .= "FROM phpbb_topics AS t, phpbb_users AS u, phpbb_posts AS p, phpbb_posts_text AS pt ";
    $sql2 .= "WHERE t.forum_id = 4 AND t.topic_poster = u.user_id AND t.topic_id = p.topic_id AND pt.post_id = p.post_id AND t.topic_type = 0 AND t.topic_time <> p.post_time AND t.topic_id = {$id} ";
    $sql2 .= "ORDER BY p.post_time DESC ";
    $res2 = mysql_query($sql2);
    unset($elements);
    for ($i = 0; ; $i++) {
      // try to get the next item
      $row2 = mysql_fetch_assoc($res2);
      if ($row2 == "") break;
      $elements[$i] = $row2;
    }

    $done = false;
    while (!$done) {
      $done = true;
      for ($i = 0; $i <= count($elements) - 1; $i++) {
        if (substr($elements[$i]['post_subject'], 0, 1) == '$') {
          $num = substr($elements[$i]['post_subject'], 1, strpos($elements[$i]['post_subject'], ' ')-1);
          $elements[$i]['post_subject'] = substr($elements[$i]['post_subject'], strpos($elements[$i]['post_subject'], ' ')+1);
          swap($elements, $num, $i);
          $done = false;
        }
      }
    }

    // now display the sorted elements:
    foreach ($elements as $row2) {
      // switch color to allow more easy browsing:
      $curcolor = ($curcolor + 1) % 2;

      //Retrieve the fields to variables
      $id = $row2['topic_id'];
      $poster = $row2['topic_poster'];
      $time = $row2['post_time'];
      $numcomm = $row2['topic_replies'];
      $title = $row2['post_subject'];
      $username = $row2['username'];
      $usermail = $row2['user_email'];
      $post_text = $row2['post_text'];
      $first = $row2['first_post'];

      //Get the links from the text
      $tc = explode("---", $post_text);
      $desc = $tc[0];
      if (count($tc) > 1)
  	    $links = explode("\n", $tc[1]);
      else
        $links = array();
      $urls = array();
      $urls['size'] = 0;
      $urls['date'] = 0;
      
      //Do extra parsing
      $desc = $bbcode->parse($desc);
      if ($urls['date'] == 0)
        $time = date("Y-m-d", $time);
      else
        $time = date("Y-m-d", $urls['date']);

      //Fill the urls array with nice info
      foreach ($links as $link) {
        if (strlen($link) > 10) {
  	    	$url = parse_url(trim($link));
  				$scheme = strtolower($url['scheme']);
  
          switch ($scheme) {
          	case "bt":
            	$file = $url['host'];
              // $str = '<a href="http://taspring.clan-sy.com:443/torrent.html?info_hash=' . $files[$file]['hash'] . '">Bittorrent';
              $str = '<a href="http://taspring.clan-sy.com:8080/torrents/' . $files[$file]['hash'] . '.torrent">Bittorrent';
              $s = $files[$file]['seeds'];
              $p = $files[$file]['peers'];
              $urls['size'] = $files[$file]['size'];

              $str .= " ($s seed";
              if ($s != 1)
  	            $str .= "s";
              $str .= ", $p peer";
              if ($p != 1)
                $str .= "s";
              $str .= ")";

              array_push($urls, $str);
            	break;
            case "http":
              $str = '<a href="' . trim($link) . '">' . $url['host'] . '</a>';
              array_push($urls, $str);

              //Try to figure out size if this file is not available on bt
              if ($urls['size'] == 0) {
              	if ($url['host'] == "taspring.clan-sy.com") {
                	$rn = "/var/wwwroot/spring" . $url['path'];
                  //$urls['size'] = filesize($rn);
                }
              }

             	if ($url['host'] == "taspring.clan-sy.com") {
             	  $rn = "/var/wwwroot/spring" . $url['path'];
                //$urls['date'] = filemtime($rn);
              }

              break;
            default:
              break;
          }
        }
      }

	    print('<tr valign="top" bgcolor="#' . $colors[$curcolor] . '"><td>');
	    print('<b>' . substr($title, 0) . '</b>');
	    print('<br>');

      $size = (int)$urls['size'];
      if ($size < 1024)
        $fsize = sprintf("%.1fb", $size);
      else if ($size < 1024*1024)
        $fsize = sprintf("%.1fkb", $size / 1024);
      else if ($size < 1024*1024*1024)
        $fsize = sprintf("%.1fmb", $size / (1024*1024));

	    print('<font size="-2">' . $fsize . ', added ' . $time . '</font>');
  	  print('</td>');

	    print('<td>');
	    print($desc);
	    print('</td>');

	    print('<td>');
	    foreach ($urls as $key => $url) {
        if (($key !== "size") && ($key !== "date")) {
		    	print($url);
		      print('<br>');
        }
	    } // foreach
	    print('</td></tr>');

    } // foreach (inner loop)

    print('</table>');
?>
					</DIV>
				</DIV>
<?php

  } // while (outer)

?>
			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>
