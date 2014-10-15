<?php
/**
 * See skin.txt
 *
 * @todo document
 * @addtogroup Skins
 */

if( !defined( 'MEDIAWIKI' ) )
	die( -1 );

/**
 * @todo document
 * @addtogroup Skins
 */
class SkinSpringNew extends Skin {

	private $searchboxes = '';
	// How many search boxes have we made?  Avoid duplicate id's.

	function getStylesheet() {
		return 'common/spring.css';
	}
	function getSkinName() {
		return "springnew";
	}

	function doBeforeContent() {
		$s = "";
		$qb = $this->qbSetting();
		$mainPageObj = Title::newMainPage();

		//added by Tim Blokdijk, same trick with the messageboard.
		global $site_configuration;
		global $spring_db;

		$cd = "../";
		$page_name = "wiki";
		require_once($_SERVER['DOCUMENT_ROOT'] . '/../configuration.php');
		require_once('../include/db.php');
		require_once("../include/classes.php");
		session_start();
		site_theme::set_session_theme();
		site_language::set_session_language();
		$text = site_language::text('header', $_SESSION[language]);
		array_walk($text, array('site_language', 'clean_text'));
		ob_start();
		include_once($cd."theme/".$site_theme."/html/page_header.php");
		$s .= ob_get_contents();
		ob_end_clean();

		$s .= "<DIV ID=\"site\">";

//        $s .= file_get_contents('../inc/header.php');

        $s .= "\n<div id='content'>\n";
        $s .= "<div id='article'>";

		$notice = wfGetSiteNotice();
		if( $notice ) {
			$s .= "\n<div id='siteNotice'>$notice</div>\n";
		}
		$s .= $this->pageTitle();
//		$s .= $this->pageSubtitle() . "\n";
		return $s;
	}

	function doAfterContent()
	{
		global $wgUser, $wgOut;

		$s = "\n</div><br clear='all' />\n";

        // category fix
        $catstr = $this->getCategories();
        if (strlen($catstr) > 2) {
            $s .= '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr>';
            $s .= '<td width="10">&nbsp;</td><td>';

            $s .= '<table border="0" cellpadding="2" width="100%" id="toc"><tr><td>';
            $s .= $catstr;
            $s .= '</td></tr></table>';

            $s .= '</td><td width="10">&nbsp;</td></tr></table>';
        }

        $qb = $this->qbSetting();
        if ( 0 != $qb ) { $s .= $this->quickBar(); }

		$s .= "\n<div id='footer'>";
		$s .= "<table width='98%' border='0' cellspacing='0'><tr>";

        $s .= '<td><img src="/res/trans.gif" width="2" height="6" border="0"></td></tr><tr>';
        $s .= '<td colspan="2"><img src="/res/hrsmall.gif" width="748" height="2" border="0"></td></tr><tr>';

		$s .= "<td class='bottom' align='left' valign='top'>&nbsp;&nbsp;";

        $s .= $this->searchForm(wfMsg("qbfind"));

        $s .= "</td><td class='bottom' align='right'>";
        $s .= '<a href="http://www.mediawiki.org">MediaWiki</a>&nbsp;&nbsp;';

		$s .= "</td>";
		$s .= "</tr></table>\n</div>\n";

	//removed by Tim Blokdijk, I don't use a footer anymore.
//    $s .= file_get_contents('../inc/footer.php');

		return $s;
	}

	function doGetUserStyles() {
		global $wgOut;
		$s = parent::doGetUserStyles();
		$qb = $this->qbSetting();

        $s .= "#quickbar { position: relative; left: 4px; }\n" .
        "#article { margin-left: 10px; margin-right: 10px; }\n";

		return $s;
	}

	function sysLinks() {
		global $wgUser, $wgContLang, $wgTitle;
		$li = $wgContLang->specialPage("Userlogin");
		$lo = $wgContLang->specialPage("Userlogout");

		$rt = $wgTitle->getPrefixedURL();
		if ( 0 == strcasecmp( urlencode( $lo ), $rt ) ) {
			$q = "";
		} else {
			$q = "returnto={$rt}";
		}

		/* show links to different language variants */
		$s .= $this->variantLinks();
		$s .= $this->extensionTabLinks();

		$s .= " | ";
		if ( $wgUser->isLoggedIn() ) {
			$s .=  $this->makeKnownLink( $lo, wfMsg( "logout" ), $q );
		} else {
			$s .=  $this->makeKnownLink( $li, wfMsg( "login" ), $q );
		}

		return $s;
	}

	/**
	 * Compute the sidebar
	 * @access private
	 */
	function quickBar()
	{
		global $wgOut, $wgTitle, $wgUser, $wgLang, $wgContLang, $wgEnableUploads;

		$tns=$wgTitle->getNamespace();

		$s = "\n<div id='quickbar'>";

		$s .= '<img src="/res/hrsmall.gif" width="748" height="2" border="0">';
        $s .= '<table border="0" cellpadding="0" cellspacing="4" width="758"><tr valign="top"><td>';

		$sep = "<br />";
		//$s .= $this->menuHead( "qbfind" );
		//$s .= $this->searchForm();

		$s .= $this->menuHead( "qbbrowse" );

		# Use the first heading from the Monobook sidebar as the "browse" section
		$bar = $this->buildSidebar();
		$browseLinks = reset( $bar );

		foreach ( $browseLinks as $link ) {
			if ( $link['text'] != '-' ) {
				$s .= "<a href=\"{$link['href']}\">" .
					htmlspecialchars( $link['text'] ) . '</a>' . $sep;
			}
		}

		if ( $wgOut->isArticle() ) {
            $s .= '</td><td>';

			$s .= $this->menuHead( "qbedit" );
			$s .= "<strong>" . $this->editThisPage() . "</strong>";

			$s .= $sep . $this->makeKnownLink( wfMsgForContent( "edithelppage" ), wfMsg( "edithelp" ) );

			if( $wgUser->isLoggedIn() ) {
				$s .= $sep . $this->moveThisPage();
			}
			if ( $wgUser->isAllowed('delete') ) {
				$dtp = $this->deleteThisPage();
				if ( "" != $dtp ) {
					$s .= $sep . $dtp;
				}
			}
			if ( $wgUser->isAllowed('protect') ) {
				$ptp = $this->protectThisPage();
				if ( "" != $ptp ) {
					$s .= $sep . $ptp;
				}
			}
			$s .= $sep;
            $s .= '</td><td>';

			$s .= $this->menuHead( "qbpageoptions" );
			$s .= $this->talkLink()
			  . $sep . $this->commentLink()
			  . $sep . $this->printableLink();
			if ( $wgUser->isLoggedIn() ) {
				$s .= $sep . $this->watchThisPage();
			}

			$s .= $sep;
            $s .= '</td><td>';

			$s .= $this->menuHead("qbpageinfo")
			  . $this->historyLink()
			  . $sep . $this->whatLinksHere()
			  . $sep . $this->watchPageLinksLink();

			if( $tns == NS_USER || $tns == NS_USER_TALK ) {
				$id=User::idFromName($wgTitle->getText());
				if ($id != 0) {
					$s .= $sep . $this->userContribsLink();
					if( $this->showEmailUser( $id ) ) {
						$s .= $sep . $this->emailUserLink();
					}
				}
			}
			$s .= $sep;
		}
        $s .= '</td><td>';

		$s .= $this->menuHead( "qbmyoptions" );
		if ( $wgUser->isLoggedIn() ) {
			$name = $wgUser->getName();
			$tl = $this->makeKnownLinkObj( $wgUser->getTalkPage(),
				wfMsg( 'mytalk' ) );
			if ( $wgUser->getNewtalk() ) {
				$tl .= " *";
			}

			$s .= $this->makeKnownLinkObj( $wgUser->getUserPage(),
				wfMsg( "mypage" ) )
			  . $sep . $tl
			  . $sep . $this->specialLink( "watchlist" )
			  . $sep . $this->makeKnownLinkObj( SpecialPage::getSafeTitleFor( "Contributions", $wgUser->getName() ),
			  	wfMsg( "mycontris" ) )
		  	  . $sep . $this->specialLink( "preferences" )
		  	  . $sep . $this->specialLink( "userlogout" );
		} else {
			$s .= $this->specialLink( "userlogin" );
		}

        $s .= '</td><td>';

		$s .= $this->menuHead( "qbspecialpages" )
		  . $this->specialLink( "newpages" )
		  . $sep . $this->specialLink( "imagelist" )
		  . $sep . $this->specialLink( "statistics" )
		  . $sep . $this->bugReportsLink();
		if ( $wgUser->isLoggedIn() && $wgEnableUploads ) {
			$s .= $sep . $this->specialLink( "upload" );
		}
		global $wgSiteSupportPage;
		if( $wgSiteSupportPage) {
			$s .= $sep."<a href=\"".htmlspecialchars($wgSiteSupportPage)."\" class =\"internal\">"
			      .wfMsg( "sitesupport" )."</a>";
		}

		$s .= $sep . $this->makeKnownLinkObj(
			SpecialPage::getTitleFor( 'Specialpages' ),
			wfMsg( 'moredotdotdot' ) );

        $s .= '</td></tr></table>';

		$s .= $sep . "\n</div>\n";
		return $s;
	}

	function menuHead( $key )
	{
		$s = "\n<h6>" . wfMsg( $key ) . "</h6>";
		return $s;
	}

	function searchForm( $label = "" )
	{
		global $wgRequest;

		$search = $wgRequest->getText( 'search' );
		$action = $this->escapeSearchLink();
		$s = "<form id=\"searchform{$this->searchboxes}\" method=\"get\" class=\"inline\" action=\"$action\">";
		if ( "" != $label ) { $s .= "{$label}: "; }

		$s .= "<input type='text' id=\"searchInput{$this->searchboxes}\" class=\"mw-searchInput\" name=\"search\" size=\"14\" value=\""
		  . htmlspecialchars(substr($search,0,256)) . "\" /> "
		  . "<input type='submit' id=\"searchGoButton{$this->searchboxes}\" class=\"searchButton\" name=\"go\" value=\"" . htmlspecialchars( wfMsg( "searcharticle" ) ) . "\" />"
		  . "<input type='submit' id=\"mw-searchButton{$this->searchboxes}\" class=\"searchButton\" name=\"fulltext\" value=\"" . htmlspecialchars( wfMsg( "search" ) ) . "\" /></form>";

		// Ensure unique id's for search boxes made after the first
		$this->searchboxes = $this->searchboxes == '' ? 2 : $this->searchboxes + 1;

//        $s .= '</DIV>'; This is not working like I need it to (close the site div)

		return $s;
	}
}

?>
