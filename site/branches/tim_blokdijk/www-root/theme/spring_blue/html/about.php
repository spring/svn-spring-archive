<DIV ID="site">
	<DIV ID="container" CLASS="container">
		<DIV CLASS="edge">
			<DIV CLASS="back">

				<DIV CLASS="row">
					<DIV ID="project_description_cel" CLASS="cel">
						<DIV ID="project_description_title"><?= $text[project_description_title] ?></DIV>
						<P ID="project_description_text"><?= $text[project_description_text] ?></P>
					</DIV>
				</DIV>

				<DIV CLASS="row">
					<DIV ID="developers_cel" CLASS="cel">
						<DIV ID="developers_title"><?= $text[developers_title] ?> <SPAN ID="pro_news_in_english"><?= $text[developers_in_english] ?></SPAN></DIV>
						<MARQUEE ID="developers_text" SCROLLAMOUNT="1" SCROLLDELAY="10" DIRECTION="up" WIDTH="100%" HIGHT="100%" STYLE="text-align: center;">
						<?php include_once($cd."credits.txt"); ?>
						</MARQUEE>
					</DIV>
				</DIV>

				<DIV CLASS="clear"></DIV>

			</DIV>
		</DIV>
	</DIV>
	<BR>
</DIV>
