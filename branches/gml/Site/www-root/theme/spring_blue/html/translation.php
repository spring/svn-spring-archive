<?php
/* Some possible additions in the future:

Make it possible to add a language to the database.

Make it possible to add a page to the database with:
ALTER TABLE `site_language` ADD `translation` TEXT CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL ;

Make it possible to remove a string from the development language.


	<OPTION VALUE="development">Development</OPTION>
	<OPTION VALUE="english">English - English</OPTION>
	<OPTION VALUE="german">Deutsch - German</OPTION>
	<OPTION VALUE="french">Français - French</OPTION>
	<OPTION VALUE="polish">Polski - Polish</OPTION>
	<OPTION VALUE="japanese">日本語 - Japanese</OPTION>
	<OPTION VALUE="italian">Italiano - Italian</OPTION>
	<OPTION VALUE="dutch">Nederlands - Dutch</OPTION>
	<OPTION VALUE="portuguese">Português - Portuguese</OPTION>
	<OPTION VALUE="spanish">Español - Spanish</OPTION>
	<OPTION VALUE="swedish">Svenska - Swedish</OPTION>
	<OPTION VALUE="arabic">Arabic - عربي</OPTION>

	<OPTION VALUE="english">Ask for more...</OPTION>
ç

*/


if (FALSE == $_POST)
{
// Display introduction page.
?>

<DIV ID="site">
	<DIV ID="container" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

				<DIV CLASS="row">
					<DIV ID="project_description_cel" CLASS="cel">
						<DIV ID="translation_title">Translation Page</DIV>
						<P ID="project_description_text">

							Select a section to translate:<BR>
							<FORM METHOD="post" NAME="lang_select" accept-charset="utf-8">

							<SELECT NAME="trans_section">
							<?php
							$sections = site_language::available_sections();
							foreach($sections as $section)
							{
								echo "<OPTION VALUE=\"".$section."\">".$section."</OPTION>";
							}
							?>
							</SELECT>
							<BR>

							Select a language to translate to:<BR>
							<SELECT NAME="trans_to">
							<?php
							$languages = site_language::available_languages($site_configuration[language][special][translation]);
							foreach($languages as $language => $native_name)
							{
								echo "<OPTION VALUE=\"".$language."\">".$native_name." (".$language.")</OPTION>";
							}
							?>
							</SELECT>
							<BR>
							Select a language to translate from:<BR>
							<SELECT NAME="trans_from">
							<?php
							$languages = site_language::available_languages($site_configuration[language][special][translation]);
							foreach($languages as $language => $native_name)
							{
								echo "<OPTION VALUE=\"".$language."\">".$native_name." (".$language.")</OPTION>";
							}
							?>
							</SELECT>
							<BR>
							<BR>
							<INPUT TYPE="hidden" NAME="trans_stage" VALUE="1">
							<INPUT TYPE="submit" VALUE="Continue">

							</FORM>

					</P>
					</DIV>
				</DIV>

			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>

<?php
}

// Display translation page

elseif (1 == $_POST[trans_stage])
{
	$development = site_language::text($_POST[trans_section], 'development');

	if (site_language::check_language_available_for_section($_POST[trans_section], $_POST[trans_to]))
	{
		$trans_to = site_language::text($_POST[trans_section], $_POST[trans_to]);
	}
	else
	{
		$trans_to_remark = "(there is no existing translation for this page in this language)";
	}

	if (site_language::check_language_available_for_section($_POST[trans_section], $_POST[trans_from]))
	{
		$trans_from = site_language::text($_POST[trans_section], $_POST[trans_from]);
	}
	else
	{
		$trans_from_remark = "(there is no existing translation for this page in this language)";
	}

?>

<DIV ID="site">
	<DIV ID="container" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

				<DIV CLASS="row">
					<DIV ID="project_description_cel" CLASS="cel">
						<DIV ID="translation_title">Translation Page (<I><?= $_POST[trans_section] ?> page</I>)</DIV>
						<B>Welcome to the translation system.</B><BR>
						You can use the following sub-set of phpbb codes for some simple mark-up:<BR>
						Links work like this [url=translation]linking to the translation page[/url].<BR>
						[b]bold[/b] for <B>bold</B> text.<BR>
						[i]italics[/i] for <I>italics</I>.<BR>
						And [u]under-line[/u] for <U>under-lines</U><BR>
						It's all reasonably simple, no HTML knowledge is needed (or possible..).<BR>
					</DIV>
				</DIV>

				<DIV CLASS="row">
					<DIV ID="developers_cel" CLASS="cel">
						<DIV ID="string_table_title">String Table</DIV>
<?php
	echo "
	<FORM METHOD=\"post\" ID=\"translation\" accept-charset=\"utf-8\">
	<TABLE ID=\"table\" BORDER=\"1\" WIDTH=\"100%\">
	<TR><TH>Variable</TH><TH>".$_POST[trans_to]." ".$trans_to_remark."</TH><TH>".$_POST[trans_from]." ".$trans_from_remark."</TH></TR>";

	foreach ($development as $key => $value)
	{
		if(strlen($trans_from[$key]) > 100 || strlen($trans_from[$key]) == 0) {$rows = 8;} else {$rows = 1;}
	    echo "\n<TR><TD WIDTH=\"1%\" ALIGN=\"right\"><B>".$key."</B>:</TD><TD><TEXTAREA STYLE=\"width: 100%;\" ROWS=\"".$rows."\" NAME=\"".$key."\">".$trans_to[$key]."</TEXTAREA></TD><TD WIDTH=\"20%\">".str_replace(array("\r\n", "\r", "\n"), "<BR>", htmlspecialchars($trans_from[$key], ENT_QUOTES, 'UTF-8'))."</TD></TR>";
	}
	echo "
	</TABLE><BR>
	";

	if ("development" == $_POST[trans_to])
	{
		echo "
		<BUTTON ONCLICK=\"GiveRow();\" TYPE=\"button\">Extra row</BUTTON><BR><BR>

		<SCRIPT TYPE=\"text/javascript\">
		var nr = 1;
		function GiveRow()
		{
			var tr=document.createElement('tr');
			var td1=document.createElement('td');
			tr.appendChild(td1);
			var b=document.createElement('b');
			td1.appendChild(b);
			var input=document.createElement('input');
			input.type=\"text\"
			input.name=\"extra_key_\" + nr;
			b.appendChild(input);
			var td2=document.createElement('td');
			tr.appendChild(td2);
			var textarea=document.createElement('textarea');
			textarea.style.width=\"100%\"
			textarea.rows=\"8\"
			textarea.name=\"extra_value_\" + nr;
			td2.appendChild(textarea);

			document.getElementById('table').appendChild(tr);

			nr ++;
		}
		</SCRIPT>

		Version increase:<BR>
		Major: <INPUT VALUE=\"major\" TYPE=\"radio\" NAME=\"trans_version\"><BR>
		Minor: <INPUT VALUE=\"minor\" TYPE=\"radio\" NAME=\"trans_version\" CHECKED><BR>
	";
	}
	else
	{
		echo "
		<!-- Version: (Major: <INPUT SIZE=\"3\" TYPE=\"text\" NAME=\"trans_major\">) (Minor: <INPUT SIZE=\"3\" TYPE=\"text\" NAME=\"trans_minor\">)<BR><BR> -->
		";
	}

	echo "
	<BR>
	Your messageboard username: <INPUT TYPE=\"text\" NAME=\"trans_user\"><!--	Your messageboard password: <INPUT DISABLED TYPE=\"password\" NAME=\"trans_pass\"><BR> -->
	<INPUT TYPE=\"hidden\" NAME=\"trans_section\" VALUE=\"".$_POST[trans_section]."\">
	<INPUT TYPE=\"hidden\" NAME=\"trans_to\" VALUE=\"".$_POST[trans_to]."\">
	<INPUT TYPE=\"hidden\" NAME=\"trans_stage\" VALUE=\"2\">
	<INPUT TYPE=\"submit\" VALUE=\"Process translation\">
	</FORM>
	";

?>
					</DIV>
				</DIV>

				<DIV CLASS="clear"></DIV>

			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>

<?php

}

// Process translation

elseif (2 == $_POST[trans_stage])
{
		echo"<PRE>";print_r($_POST);echo"</PRE>"; // (Debugging)

	$tmp_text = $_POST;
	unset($tmp_text[trans_stage], $tmp_text[trans_to], $tmp_text[trans_section], $tmp_text[trans_user], $tmp_text[trans_pass], $tmp_text[trans_version]);
	
	foreach($tmp_text as $key => $value)
	{
		if (substr ($key, 0, 10) == "extra_key_")
		{
			$nr = substr ($key, 10, 3);
			$text[$value] = $tmp_text['extra_value_'.$nr];
		}
		elseif (substr ($key, 0, 12) == "extra_value_")
		{
			// Do nothing.
		}
		else
		{
			$text[$key] = $value;
		}
	}

	echo"<PRE>";print_r($text);echo"</PRE>"; // (Debugging)

	if ("development" == $_POST[trans_to])
	{
		$version = site_language::version($_POST[trans_section], "development");

		if ("major" == $_POST[trans_version])
		{
			$version[major] ++;
			$version[minor] = 0;
		}
		elseif ("minor" == $_POST[trans_version])
		{
			$version[minor] ++;
		}
	}
	else
	{
		$version = site_language::version($_POST[trans_section], "development");
	}

	$save = new site_language();
	$save->set_text($text);
	$save->set_section($_POST[trans_section]);
	$save->set_language($_POST[trans_to]);
	$save->set_user($_POST[trans_user], $_POST[trans_pass]);
	$save->set_major($version[major]);
	$save->set_minor($version[minor]);
	$save->save_text();
}
?>

</BODY>
</HTML>
