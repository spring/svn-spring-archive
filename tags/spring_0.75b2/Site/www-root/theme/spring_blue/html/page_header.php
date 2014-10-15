<?php
if ('messageboard' != $page_name && 'wiki' != $page_name)
{
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>The Spring RTS Project</TITLE>
<META NAME="copyright" CONTENT="Copyright &copy; 2007 - Released under GPL">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=utf-8">
<LINK REL="shortcut icon" HREF="img/favicon.ico" TYPE="image/x-icon">
<?php
}

if($css)
{
	echo "<STYLE TYPE=\"text/css\">\n";
	include_once($cd."theme/".$site_theme."/css/css.php"); // CSS include's.
	echo "</STYLE>";
}

if ('messageboard' != $page_name && 'wiki' != $page_name)
{
?>
</HEAD>
<BODY onresize=ScreenResize();>
<?php
}

?>
<DIV ID="header">
	<DIV ID="banner">
		<A HREF="<?= $cd ?>index.php" TITLE="<?= $text[logo_tooltip] ?>">
			<IMG ID="project_logo" SRC="<?= $cd ?>theme/<?= $site_theme ?>/img/banner/project-logo.png">
		</A>
<!--
		<A HREF="<?= $cd ?>download" TITLE="<?= $text[download_tooltip] ?>">
			<IMG ID="download_button" SRC="<?= $cd ?>theme/<?= $site_theme ?>/img/banner/dl-button.png">
		</A>
-->
		<DIV ID="banner_img_left"></DIV>
		<DIV ID="project_mission_cel">
			<DIV CLASS="project_name" ID="mission_name"><?= $text[mission_name] ?></DIV><DIV ID="mission_tekst"><?= $text[mission_text] ?></DIV>
		</DIV>
		<DIV ID="banner_img_right"></DIV>

		<DIV CLASS="clear"></DIV>
	</DIV>

	<DIV ID="menu">
		<DIV ID="menu_left"></DIV>

		<DIV STYLE="float: left;">
			<A HREF="<?= $cd ?>news" TITLE="<?= $text[news_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="news_text"><?= $text[news] ?></DIV>
				<DIV CLASS="r_separator"></DIV>
			</A>
			<A HREF="<?= $cd ?>wiki" TITLE="<?= $text[wiki_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="wiki_text"><?= $text[wiki] ?></DIV>
				<DIV CLASS="r_separator"></DIV>
			</A>
			<A HREF="<?= $cd ?>messageboard" TITLE="<?= $text[messageboard_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="messageboard_text"><?= $text[messageboard] ?></DIV>
				<DIV CLASS="r_separator"></DIV>
			</A>
			<A HREF="<?= $cd ?>about" TITLE="<?= $text[about_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="about_text"><?= $text[about] ?></DIV>
				<DIV CLASS="r_separator"></DIV>
			</A>
		</DIV>

		<DIV STYLE="width: 20px; height: 30px; float: left;"></DIV>

		<DIV STYLE="float: left;">
			<A HREF="<?= $cd ?>development" TITLE="<?= $text[development_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="development_text"><?= $text[development] ?></DIV>
				<DIV CLASS="r_separator"></DIV>
			</A>
		</DIV>

		<DIV ID="menu_right"></DIV>

		<DIV ID="language">
			<DIV ID="language_list" STYLE="text-align: center; background-color: #559; border: 1px solid #888E9D; border-bottom-style: none; border-top-style: none;">
				<A HREF="<?= $cd ?>index.php?language=english&theme=<?= $_GET[theme] ?>" TITLE="English"><DIV STYLE="padding: 5px;">English</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=german&theme=<?= $_GET[theme] ?>" TITLE="German"><DIV STYLE="padding: 5px;">Deutsch</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=french&theme=<?= $_GET[theme] ?>" TITLE="French"><DIV STYLE="padding: 5px;">Français</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=polish&theme=<?= $_GET[theme] ?>" TITLE="Polish"><DIV STYLE="padding: 5px;">Polski</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=japanese&theme=<?= $_GET[theme] ?>" TITLE="Japanese"><DIV STYLE="padding: 5px;">日本語</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=italian&theme=<?= $_GET[theme] ?>" TITLE="Italian"><DIV STYLE="padding: 5px;">Italiano</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=dutch&theme=<?= $_GET[theme] ?>" TITLE="Dutch"><DIV STYLE="padding: 5px;">Nederlands</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=portuguese&theme=<?= $_GET[theme] ?>" TITLE="Portuguese"><DIV STYLE="padding: 5px;">Português</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=spanish&theme=<?= $_GET[theme] ?>" TITLE="Spanish"><DIV STYLE="padding: 5px;">Español</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=swedish&theme=<?= $_GET[theme] ?>" TITLE="Swedish"><DIV STYLE="padding: 5px;">Svenska</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=arabic&theme=<?= $_GET[theme] ?>" TITLE="Arabic"><DIV STYLE="padding: 5px;">عربي</DIV></A>
			</DIV>
			<DIV ID="language_button" TITLE="<?= $text[language_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="language_text"><?= $text[language] ?> <SPAN ID="language_arr">&uarr;</SPAN></DIV>
				<DIV CLASS="r_separator"></DIV>
			</DIV>
		</DIV>

		<DIV ID="theme">
			<DIV ID="theme_list" STYLE="background-color: #559; border: 1px solid #888E9D; border-bottom-style: none; border-top-style: none;">
				<A HREF="<?= $cd ?>index.php?language=<?= $_GET[language] ?>&theme=spring_blue" TITLE="The standard &quot;Spring Blue&quot; theme"><DIV STYLE="padding: 5px">Spring Blue</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=<?= $_GET[language] ?>&theme=nano_blobs" TITLE="The &quot;NanoBlobs&quot; theme"><DIV STYLE="padding: 5px">NanoBlobs</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=<?= $_GET[language] ?>&theme=kernel_panic" TITLE="The &quot;Kernel Panic&quot; theme"><DIV STYLE="padding: 5px">Kernel Panic</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=<?= $_GET[language] ?>&theme=total_annihilation" TITLE="The &quot;Total Annihilation&quot;&trade; theme"><DIV STYLE="padding: 5px">Total Ann...&trade;</DIV></A>
				<A HREF="<?= $cd ?>index.php?language=<?= $_GET[language] ?>&theme=star_wars" TITLE="The &quot;Star Wars&quot;&trade; theme"><DIV STYLE="padding: 5px">Star Wars&trade;</DIV></A>
			</DIV>
			<DIV ID="theme_button" TITLE="<?= $text[theme_tooltip] ?>">
				<DIV CLASS="l_separator"></DIV>
				<DIV ID="theme_text"><?= $text[theme] ?> <SPAN ID="theme_arr">&uarr;</SPAN></DIV>
				<DIV CLASS="r_separator"></DIV>
			</DIV>
		</DIV>
	</DIV>
</DIV>

<SCRIPT TYPE="text/javascript">
<!--
function MenuMove(object, act)
{
	obj = document.getElementById(object);
	objlist = document.getElementById(object + '_list');
	arr = document.getElementById(object + '_arr');
	button = document.getElementById(object + '_button');
	var objname = obj.id;
	if (act == close)
	{
		obj.style.top = obj.offsetTop - objlist.offsetHeight + "px";
		arr.firstChild.nodeValue = '↓';
		button.onclick = function () { MenuMove(objname, open); };
		button.style.cursor = "pointer";
		button.title = "Click to open the " + objname + " selection menu";
	}
	if (act == open)
	{
		obj.style.top = obj.offsetTop + objlist.offsetHeight + "px";
		arr.firstChild.nodeValue = '↑';
		button.onclick = function () { MenuMove(objname, close); };
		button.title = "Click on a " + objname + " or click here to close the " + objname + " selection menu";
	}
}

if(document.getElementById && document.createTextNode)
{
	// JavaScrip is enabled

	// Timers for menu close
	setTimeout('MenuMove("theme", close)', 0000);
	setTimeout('MenuMove("language", close)', 0000);
}
-->
</SCRIPT>


<DIV CLASS="clear"></DIV>

<?php
unset($text);
?>
