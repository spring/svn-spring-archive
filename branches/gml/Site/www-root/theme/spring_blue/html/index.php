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
							<P ID="highlight_text">
							<?= site_news::get_news($site_configuration[news][forum_id][highlight], 1, 'text') ?>
							</P>
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
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen0.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen0.jpg" TITLE="<?= $text[screenshots_tooltip] ?>"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen1.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen1.jpg" TITLE="<?= $text[screenshots_tooltip] ?>"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen2.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen2.jpg" TITLE="<?= $text[screenshots_tooltip] ?>"></A>
					<A TARGET=_Blank HREF="theme/<?= $site_theme ?>/img/screenshots/screen3.jpg"><IMG CLASS="screenshot" SRC="theme/<?= $site_theme ?>/img/screenshots/thumbnail_screen3.jpg" TITLE="<?= $text[screenshots_tooltip] ?>"></A>
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
							<?= site_news::get_news($site_configuration[news][forum_id][community_news], 3, 'short') ?>
						</DIV>
					</DIV>

					<DIV CLASS="col">
						<DIV ID="pron_cel" CLASS="r_cel">
							<DIV ID="pro_news_title"><?= $text[pro_news_title] ?> <SPAN ID="pro_news_in_english"><?= $text[pro_news_in_english] ?></SPAN></DIV>
							<?= site_news::get_news($site_configuration[news][forum_id][project_news], 3, 'short') ?>
						</DIV>
					</DIV>

					<DIV CLASS="clear"></DIV>
				</DIV>
			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>
