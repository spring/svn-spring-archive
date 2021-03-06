<?php
/**
 *
 * @package MediaWiki
 * @subpackage SpecialPage
 */

/**
 *
 */
require_once( "SpecialRecentchanges.php" );
require_once( "WatchedItem.php" );

/**
 * constructor
 */
function wfSpecialWatchlist() {
	global $wgUser, $wgOut, $wgLang, $wgTitle, $wgMemc, $wgRequest;
	global $wgUseWatchlistCache, $wgWLCacheTimeout, $wgDBname;
	$fname = "wfSpecialWatchlist";

	$wgOut->setPagetitle( wfMsg( "watchlist" ) );
	$sub = wfMsg( "watchlistsub", $wgUser->getName() );
	$wgOut->setSubtitle( $sub );
	$wgOut->setRobotpolicy( "noindex,nofollow" );

	$specialTitle = Title::makeTitle( NS_SPECIAL, "Watchlist" );

	$uid = $wgUser->getID();
	if( $uid == 0 ) {
		$wgOut->addHTML( wfMsg( "nowatchlist" ) );
		return;
	}

	# Get query variables
	$days = $wgRequest->getVal( 'days' );
	$action = $wgRequest->getVal( 'action' );
	$remove = $wgRequest->getVal( 'remove' );
	$id = $wgRequest->getVal( 'id' );

	if(($action == "submit") && isset($remove) && is_array($id)) {
		$wgOut->addHTML( wfMsg( "removingchecked" ) );
		foreach($id as $one) {
			$t = Title::newFromURL( $one );
			if( !is_null( $t ) ) {
				$wl = WatchedItem::fromUserTitle( $wgUser, $t );
				if( $wl->removeWatch() === false ) {
					$wgOut->addHTML( "<br />\n" . wfMsg( "couldntremove", htmlspecialchars($one) ) );
				} else {
					$wgOut->addHTML( " (" . htmlspecialchars($one) . ")" );
				}
			} else {
				$wgOut->addHTML( "<br />\n" . wfMsg( "iteminvalidname", htmlspecialchars($one) ) );
			}
		}
		$wgOut->addHTML( "done.\n<p>" );
	}

	if ( $wgUseWatchlistCache ) {
		$memckey = "$wgDBname:watchlist:id:" . $wgUser->getId();
		$cache_s = @$wgMemc->get( $memckey );
		if( $cache_s ){
			$wgOut->addHTML( wfMsg("wlsaved") );
			$wgOut->addHTML( $cache_s );
			return;
		}
	}

	$dbr =& wfGetDB( DB_SLAVE );
	extract( $dbr->tableNames( 'cur', 'watchlist', 'recentchanges' ) );

	$sql = "SELECT COUNT(*) AS n FROM $watchlist WHERE wl_user=$uid";
	$res = $dbr->query( $sql, $fname );
	$s = $dbr->fetchObject( $res );
	$nitems = $s->n;
	if($nitems == 0) {
        $wgOut->addHTML( wfMsg( "nowatchlist" ) );
        return;
	}
	
	if ( is_null( $days ) ) {
		$big = 1000;
		if($nitems > $big) {
			# Set default cutoff shorter
			$days = (12.0 / 24.0); # 12 hours...
		} else {
			$days = 3; # longer cutoff for shortlisters
		}
	} else {
		$days = floatval($days);
	}

	if ( $days <= 0 ) {
		$docutoff = '';
		$cutoff = false;
		$npages = wfMsg( "all" );
	} else {
		$cutoff = $dbr->timestamp( time() - intval( $days * 86400 ) );
		$docutoff = "AND cur_timestamp > '$cutoff'";

		// Excessively expensive query removed and replace with an estimate that's roughly the same on en.wikipedia.org
		// Query below was more expensive than the real watchlist queries
		/*
		$sql = "SELECT COUNT(*) AS n FROM $cur WHERE cur_timestamp>'$cutoff'";
		$res = $dbr->query( $sql, $fname );
		$s = $dbr->fetchObject( $res );
		$npages = $s->n;
		*/
		$npages = 40000 * $days;
	}

	if(isset($_REQUEST['magic'])) {
		$wgOut->addHTML( wfMsg( "watchlistcontains", $wgLang->formatNum( $nitems ) ) .
			"<p>" . wfMsg( "watcheditlist" ) . "</p>\n" );

		$wgOut->addHTML( "<form action='" .
			$specialTitle->escapeLocalUrl( "action=submit" ) .
			"' method='post'>\n" .
			"<ul>\n" );
		$sql = "SELECT wl_namespace,wl_title FROM $watchlist WHERE wl_user=$uid";
		$res = $dbr->query( $sql, $fname );
		$sk = $wgUser->getSkin();
		while( $s = $dbr->fetchObject( $res ) ) {
			$t = Title::makeTitle( $s->wl_namespace, $s->wl_title );
			if( is_null( $t ) ) {
				$wgOut->addHTML( '<!-- bad title "' . htmlspecialchars( $s->wl_title ) . '" in namespace ' . IntVal( $s->wl_namespace ) . " -->\n" );
			} else {
				$t = $t->getPrefixedText();
				$wgOut->addHTML( "<li><input type='checkbox' name='id[]' value=\"" . htmlspecialchars($t) . "\" />" .
					$sk->makeLink( $t, $t ) .
					"</li>\n" );
			}
		}
		$wgOut->addHTML( "</ul>\n" .
			"<input type='submit' name='remove' value=\"" .
			htmlspecialchars( wfMsg( "removechecked" ) ) . "\" />\n" .
			"</form>\n" );

		return;
	}

	# If the watchlist is relatively short, it's simplest to zip
	# down its entirety and then sort the results.

	# If it's relatively long, it may be worth our while to zip
	# through the time-sorted page list checking for watched items.

	# Up estimate of watched items by 15% to compensate for talk pages...
	if( $cutoff && ( $nitems*1.15 > $npages ) ) {
		$x = "cur_timestamp";
		$y = wfMsg( "watchmethod-recent" );
		$z = "wl_namespace=cur_namespace&65534";
	} else {
		$x = "name_title_timestamp";
		$y = wfMsg( "watchmethod-list" );
		$z = "(wl_namespace=cur_namespace OR wl_namespace+1=cur_namespace)";
	}


	$wgOut->addHTML( "<i>" . wfMsg( "watchdetails",
		$wgLang->formatNum( $nitems ), $wgLang->formatNum( $npages ), $y,
		$specialTitle->escapeLocalUrl( "magic=yes" ) ) . "</i><br />\n" );

	$use_index = $dbr->useIndexClause( $x );
	$sql = "SELECT
  cur_namespace,cur_title,cur_comment, cur_id,
  cur_user,cur_user_text,cur_timestamp,cur_minor_edit,cur_is_new
  FROM $watchlist,$cur $use_index
  WHERE wl_user=$uid
  AND $z
  AND wl_title=cur_title
  $docutoff
  ORDER BY cur_timestamp DESC";


	$res = $dbr->query( $sql, $fname );
	$numRows = $dbr->numRows( $res );
	if($days >= 1)
		$note = wfMsg( "rcnote", $wgLang->formatNum( $numRows ), $wgLang->formatNum( $days ) );
	elseif($days > 0)
		$note = wfMsg( "wlnote", $wgLang->formatNum( $numRows ), $wgLang->formatNum( round($days*24) ) );
	else
		$note = "";
	$wgOut->addHTML( "\n<hr />\n{$note}\n<br />" );
	$note = wlCutoffLinks( $days );
	$wgOut->addHTML( "{$note}\n" );

	if ( $numRows == 0 ) {
		$wgOut->addHTML( "<p><i>" . wfMsg( "watchnochange" ) . "</i></p>" );
		return;
	}

	$sk = $wgUser->getSkin();
	$list =& new ChangesList( $sk );
	$s = $list->beginRecentChangesList();
	$counter = 1;
	while ( $obj = $dbr->fetchObject( $res ) ) {
		# Make fake RC entry
		$rc = RecentChange::newFromCurRow( $obj );
		$rc->counter = $counter++;
		$s .= $list->recentChangesLine( $rc, true );
	}
	$s .= $list->endRecentChangesList();

	$dbr->freeResult( $res );
	$wgOut->addHTML( $s );

	if ( $wgUseWatchlistCache ) {
		$wgMemc->set( $memckey, $s, $wgWLCacheTimeout);
	}

}


function wlHoursLink( $h, $page ) {
	global $wgUser, $wgLang, $wgContLang;
	$sk = $wgUser->getSkin();
	$s = $sk->makeKnownLink(
	  $wgContLang->specialPage( $page ),
	  $wgLang->formatNum( $h ),
	  "days=" . ($h / 24.0) );
	return $s;
}


function wlDaysLink( $d, $page ) {
	global $wgUser, $wgLang, $wgContLang;
	$sk = $wgUser->getSkin();
	$s = $sk->makeKnownLink(
	  $wgContLang->specialPage( $page ),
	  ($d ? $wgLang->formatNum( $d ) : wfMsg( "all" ) ), "days=$d" );
	return $s;
}

function wlCutoffLinks( $days, $page = "Watchlist" )
{
	$hours = array( 1, 2, 6, 12 );
	$days = array( 1, 3, 7 );
	$cl = "";
	$i = 0;
	foreach( $hours as $h ) {
		$hours[$i++] = wlHoursLink( $h, $page );
	}
	$i = 0;
	foreach( $days as $d ) {
		$days[$i++] = wlDaysLink( $d, $page );
	}
	return wfMsg ("wlshowlast",
		implode(" | ", $hours),
		implode(" | ", $days),
		wlDaysLink( 0, $page ) );
}

?>
