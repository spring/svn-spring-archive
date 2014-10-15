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
							<?= site_news::get_news($site_configuration[news][forum_id][community_news], 10, 'news') ?>
						</DIV>
					</DIV>

					<DIV CLASS="col">
						<DIV ID="pron_cel" CLASS="r_cel">
							<DIV ID="pro_news_title"><?= $text[pro_news_title] ?> <SPAN ID="pro_news_in_english"><?= $text[pro_news_in_english] ?></SPAN></DIV>
							<?= site_news::get_news($site_configuration[news][forum_id][project_news], 10, 'news') ?>
						</DIV>
					</DIV>

					<DIV CLASS="clear"></DIV>
				</DIV>

			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>
