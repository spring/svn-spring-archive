<?php
/**
 * See skin.doc
 *
 * @todo document
 * @package MediaWiki
 * @subpackage Skins
 */

if( !defined( 'MEDIAWIKI' ) )
	die();

/**
 * @todo document
 * @package MediaWiki
 * @subpackage Skins
 */
class SkinSpring extends Skin {

	function getStylesheet() {
		return "common/spring.css";
	}
	function getSkinName() {
		return "spring";
	}

	function doBeforeContent() {
		global $wgUser, $wgOut, $wgTitle;

		$s = "";
		$qb = $this->qbSetting();
		$mainPageObj = Title::newMainPage();

	//added by Tim Blokdijk, same trick as with the messageboard.
	$cd = "../";
	$page_name = "wiki";
	require_once("../include/session.php");
	$text = spring_language::text('header', $_GET[language]);
	ob_start();
	echo "test";
	include_once($cd."theme/".$site_theme."/html/page_header.php");
	$s .= ob_get_contents();
	ob_end_clean();

	$s .= "<DIV ID=\"site\">";

//    $s .= file_get_contents('../inc/header.php');

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

            /*$s .= '<table border="2" cellpadding="6" cellspacing="0" width="100%" style="margin: 1em 1em 1em 0; background: #f9f9f9; border: 1px #aaa solid; border-collapse: collapse;">';
            $s .= '<tr><td>';
            $s .= $catstr;
            $s .= '</td></tr></table>'; */

            $s .= '</td><td width="10">&nbsp;</td></tr></table>';
        }

    $qb = $this->qbSetting();
    if ( 0 != $qb ) { $s .= $this->quickBar(); }

		$s .= "\n<div id='footer'>";
		$s .= "<table width='98%' border='0' cellspacing='0'><tr>";

/*		if ( 1 == $qb || 3 == $qb ) { # Left
			$s .= $this->getQuickbarCompensator();
		} */

    $s .= '<td><img src="/res/trans.gif" width="2" height="6" border="0"></td></tr><tr>';
    $s .= '<td colspan="2"><img src="/res/hrsmall.gif" width="748" height="2" border="0"></td></tr><tr>';

		$s .= "<td class='bottom' align='left' valign='top'>&nbsp;&nbsp;";

    $s .= $this->searchForm(wfMsg("qbfind"));

    $s .= "</td><td class='bottom' align='right'>";
    $s .= '<a href="http://www.mediawiki.org">MediaWiki</a>&nbsp;&nbsp;';
//    $s .= $this->sysLinks();

//		$s .= $this->bottomLinks();
/*		$s .= "\n<br />" . $this->makeKnownLink( wfMsgForContent( "mainpage" ) ) . " | "
		  . $this->aboutLink() . " | "
		  . $this->searchForm( wfMsg( "qbfind" ) ); */

//		$s .= "\n<br />" . $this->pageStats();

		$s .= "</td>";
/*		if ( 2 == $qb ) { # Right
			$s .= $this->getQuickbarCompensator();
		} */
		$s .= "</tr></table>\n</div>\n";


/*    $mainPageObj = Title::newMainPage();
    $s .= "<div id='topbar'>" .
      "<table width='100%' border='0' cellspacing='0' cellpadding='8'><tr>";

    $s .= "<td class='top' align='left' valign='middle' nowrap='nowrap'>";
    $s .= "<a href=\"" . $mainPageObj->escapeLocalURL() . "\">";
    $s .= "<span id='sitetitle'>" . wfMsg( "sitetitle" ) . "</span></a>";

    $s .= "</td><td class='top' align='right' valign='bottom' width='100%'>";
    $s .= $this->sysLinks();
    $s .= "</td></tr><tr><td valign='top'>";

    $s .= "<font size='-1'><span id='sitesub'>";
    $s .= htmlspecialchars( wfMsg( "sitesubtitle" ) ) . "</span></font>";
    $s .= "</td><td align='right'>" ;

    $s .= "<font size='-1'><span id='langlinks'>" ;
    $s .= str_replace ( "<br />" , "" , $this->otherLanguages() );
    $cat = $this->getCategoryLinks();
    if( $cat ) $s .= "<br />$cat\n";
    $s .= "<br />" . $this->pageTitleLinks();
    $s .= "</span></font>";

    $s .= "</td></tr></table>\n";

    $s .= "\n</div>";
    $s .= "\n</div>\n"; */

	//removed by Tim Blokdijk, I don't use a footer anymore.
//    $s .= file_get_contents('../inc/footer.php');

		return $s;
	}
	function doGetUserStyles()
	{
		global $wgUser, $wgOut, $wgStyleSheetPath;
		$s = parent::doGetUserStyles();
		$qb = $this->qbSetting();

    $s .= "#quickbar { position: relative; left: 4px; }\n" .
      "#article { margin-left: 10px; margin-right: 10px; }\n";

/*		if ( 2 == $qb ) { # Right
			$s .= "#quickbar { position: absolute; right: 4px; }\n" .
			  "#article { margin-left: 4px; margin-right: 148px; }\n";
		} else if ( 1 == $qb ) {
			$s .= "#quickbar { position: absolute; left: 4px; }\n" .
			  "#article { margin-left: 148px; margin-right: 4px; }\n";
		} else if ( 3 == $qb ) { # Floating
			$s .= "#quickbar { position:absolute; left:4px } \n" .
			  "#topbar { margin-left: 148px }\n" .
			  "#article { margin-left:148px; margin-right: 4px; } \n" .
			  "body>#quickbar { position:fixed; left:4px; top:4px; overflow:auto ;bottom:4px;} \n"; # Hides from IE
		} */
		return $s;
	}
	function sysLinks()
	{
		global $wgUser, $wgContLang, $wgTitle;
		$li = $wgContLang->specialPage("Userlogin");
		$lo = $wgContLang->specialPage("Userlogout");

		$rt = $wgTitle->getPrefixedURL();
		if ( 0 == strcasecmp( urlencode( $lo ), $rt ) ) {
			$q = "";
		} else { 
			$q = "returnto={$rt}"; 
		}
		
/*		$s = "" .
		  $this->makeKnownLink( wfMsgForContent( "mainpage" ), wfMsg( "mainpage" ) )
		  . " | " .
		  $this->makeKnownLink( wfMsgForContent( "aboutpage" ), wfMsg( "about" ) )
		  . " | " .
		  $this->makeKnownLink( wfMsgForContent( "helppage" ), wfMsg( "help" ) )
		  . " | " .
		  $this->makeKnownLink( wfMsgForContent( "faqpage" ), wfMsg("faq") )
		  . " | " .
		  $this->specialLink( "specialpages" ) . " | ";          */

		if ( $wgUser->getID() )
		{
			$s .=  $this->makeKnownLink( $lo, wfMsg( "logout" ), $q );
		}
		else
		{
			$s .=  $this->makeKnownLink( $li, wfMsg( "login" ), $q );
		}

		/* show links to different language variants */
		global $wgDisableLangConversion;
		$variants = $wgContLang->getVariants();
		if( !$wgDisableLangConversion && sizeof( $variants ) > 1 ) {
			$actstr = '';
			foreach( $variants as $code ) {
				$varname = $wgContLang->getVariantname( $code );
				if( $varname == 'disable' )
					continue;
				$s .= ' | <a href="' . $wgTitle->getLocalUrl( 'variant=' . $code ) . '">' . $varname . '</a>';
			}
		}



		return $s;
	}

	/**
	 * Compute the sidebar
	 * @private
	 */
	function quickBar()
	{
		global $wgOut, $wgTitle, $wgUser, $wgLang, $wgContLang, $wgDisableUploads, $wgNavigationLinks;

		$tns=$wgTitle->getNamespace();

		$s = "\n<div id='quickbar'>";

		$s .= '<img src="/res/hrsmall.gif" width="748" height="2" border="0">';

    $s .= '<table border="0" cellpadding="0" cellspacing="4" width="758"><tr valign="top"><td>';

		$sep = "<br />";
//		$s .= $this->menuHead( "qbfind" );
//		$s .= $this->searchForm();

		$s .= $this->menuHead( "qbbrowse" );

		foreach ( $wgNavigationLinks as $link ) {
			$msg = wfMsgForContent( $link['href'] );
			$text = wfMsg( $link['text'] );
			if ( $msg != '-' && $text != '-' ) {
				$s .= '<a href="' . $this->makeInternalOrExternalUrl( $msg ) . '">' .
					htmlspecialchars( $text ) . '</a>' . $sep;
			}
		}

		if ( $wgOut->isArticle() ) {

      $s .= '</td><td>';
			$s .= $this->menuHead( "qbedit" );
			$s .= "<strong>" . $this->editThisPage() . "</strong>";

			$s .= $sep . $this->makeKnownLink( wfMsgForContent( "edithelppage" ), wfMsg( "edithelp" ) );

			if ( 0 != $wgUser->getID() ) {
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
			if ( 0 != $wgUser->getID() ) {
				$s .= $sep . $this->watchThisPage();
			}

			$s .= $sep;
      $s .= '</td><td>';

			$s .= $this->menuHead("qbpageinfo")
			  . $this->historyLink()
			  . $sep . $this->whatLinksHere()
			  . $sep . $this->watchPageLinksLink();
			  
			if ( Namespace::getUser() == $tns || Namespace::getTalk(Namespace::getUser()) == $tns ) {
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
		if ( 0 != $wgUser->getID() ) {
			$name = $wgUser->getName();
			$tl = $this->makeKnownLink( $wgContLang->getNsText(
			  Namespace::getTalk( Namespace::getUser() ) ) . ":{$name}",
			  wfMsg( "mytalk" ) );
			if ( 0 != $wgUser->getNewtalk() ) { $tl .= " *"; }

			$s .= $this->makeKnownLink( $wgContLang->getNsText(
			  Namespace::getUser() ) . ":{$name}", wfMsg( "mypage" ) )
			  . $sep . $tl
			  . $sep . $this->specialLink( "watchlist" )
			  . $sep . $this->makeKnownLink( $wgContLang->specialPage( "Contributions" ),
			  	wfMsg( "mycontris" ), "target=" . wfUrlencode($wgUser->getName() ) )		
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
		if ( 0 != $wgUser->getID() && !$wgDisableUploads ) {
			$s .= $sep . $this->specialLink( "upload" );
		}
		global $wgSiteSupportPage;
		if( $wgSiteSupportPage) {
			$s .= $sep."<a href=\"".htmlspecialchars($wgSiteSupportPage)."\" class =\"internal\">"
			      .wfMsg( "sitesupport" )."</a>";
		}
		
		$s .= $sep . $this->makeKnownLink( $wgContLang->specialPage( "Specialpages" ), wfMsg("moredotdotdot") );

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
		$s = "<form id=\"search\" method=\"get\" class=\"inline\" action=\"$action\">";
		if ( "" != $label ) { $s .= "{$label}: "; }

		$s .= "<input type='text' name=\"search\" size='14' value=\""
		  . htmlspecialchars(substr($search,0,256)) . "\" />"
		  . "&nbsp;&nbsp;<input type='submit' name=\"go\" value=\"" . htmlspecialchars( wfMsg( "go" ) ) . "\" /> <input type='submit' name=\"fulltext\" value=\"" . htmlspecialchars( wfMsg( "search" ) ) . "\" /></form>";

		$s .= "</DIV>";

		return $s;
	}
}

?>
