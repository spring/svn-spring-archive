<?php
/**
 *
 * @package MediaWiki
 * @subpackage SpecialPage
 */

/**
 *
 */
function wfSpecialAllpages( $par=NULL ) {
	global $indexMaxperpage, $toplevelMaxperpage, $wgRequest, $wgOut, $wgContLang;
	$indexMaxperpage = 480;
	$toplevelMaxperpage = 50;
	$from = $wgRequest->getVal( 'from' );
	$namespace = $wgRequest->getInt( 'namespace' );
	$names = $wgContLang->getNamespaces();
	if( !isset( $names[$namespace] ) ) {
		$namespace = 0;
	}
	$wgOut->setPagetitle ( $namespace > 0 ? wfMsg ( 'allpagesnamespace', $names[$namespace] )
	                                      : wfMsg ( 'allarticles' ) );

	if ( isset($par) ) {
		indexShowChunk( $par, $namespace );
	} elseif ( isset($from) ) {
		indexShowChunk( $from, $namespace );
	} else {
		indexShowToplevel ( $namespace );
	}
}

function namespaceForm ( $namespace = 0, $from = '' ) {
	global $wgContLang, $wgScript;

	$t = Title::makeTitle( NS_SPECIAL, "Allpages" );

	$namespaceselect = '<select name="namespace">';
	$arr = $wgContLang->getNamespaces();
	foreach( $arr as $ns => $name ) {
		if ( $ns < NS_MAIN ) continue;
		$namespacename = str_replace ( "_", " ", $name );
		$n = ($ns == 0) ? wfMsg ( 'articlenamespace' ) : $namespacename;
		$sel = ($ns == $namespace) ? ' selected="selected"' : '';
		$namespaceselect .= "<option value='{$ns}'{$sel}>{$n}</option>";
	}
	$namespaceselect .= '</select>';

	$frombox = '<input type="text" size="20" name="from" value="'
	            . htmlspecialchars ( $from ) . '"/>';
	$submitbutton = '<input type="submit" value="' . wfMsg( 'allpagessubmit' ) . '" />';

	$out = "<div class='namespaceselector'><form method='get' action='{$wgScript}'>";
	$out .= '<input type="hidden" name="title" value="'.$t->getPrefixedText().'" />';
	$out .= wfMsg ( 'allpagesformtext1', $frombox ) . '<br />';
	$out .= wfMsg ( 'allpagesformtext2', $namespaceselect, $submitbutton );
	$out .= '</form></div>';
	return $out;
}

function indexShowToplevel ( $namespace = 0 ) {
	global $wgOut, $indexMaxperpage, $toplevelMaxperpage, $wgContLang, $wgRequest, $wgUser;
	$sk = $wgUser->getSkin();
	$fname = "indexShowToplevel";
	$namespace = intval ($namespace);

	# TODO: Either make this *much* faster or cache the title index points
	# in the querycache table.

	$dbr =& wfGetDB( DB_SLAVE );
	$cur = $dbr->tableName( 'cur' );
	$fromwhere = "FROM $cur WHERE cur_namespace=$namespace";
	$order_arr = array ( 'ORDER BY' => 'cur_title' );
	$order_str = 'ORDER BY cur_title';
	$out = "";
	$where = array( 'cur_namespace' => $namespace );

	$count = $dbr->selectField( 'cur', 'COUNT(*)', $where, $fname );
	$sections = ceil( $count / $indexMaxperpage );

	if ( $sections < 3 ) {
		# If there are only two or less sections, don't even display them.
		# Instead, display the first section directly.
		indexShowChunk( '', $namespace );
		return;
	}

	# We want to display $toplevelMaxperpage lines starting at $offset.
	# NOTICE: $offset starts at 0
	$offset = intval ( $wgRequest->getVal( 'offset' ) );
	if ( $offset < 0 ) { $offset = 0; }
	if ( $offset >= $sections ) { $offset = $sections - 1; }

	# Where to stop? Notice that this can take the value of $sections, but $offset can't, because if
	# we're displaying only the very last section, we still need two DB queries to find the titles
	$stopat = ( $offset + $toplevelMaxperpage < $sections )
	          ? $offset + $toplevelMaxperpage : $sections ;

	# This array is going to hold the cur_titles in order.
	$lines = array();

	# If we are going to show n rows, we need n+1 queries to find the relevant titles.
	for ( $i = $offset; $i <= $stopat; $i++ ) {
		if ( $i == $sections )			# if we're displaying the last section, we need to
			$from = $count-1;			# find the last cur_title in the DB
		else if ( $i > $offset )
			$from = $i * $indexMaxperpage - 1;
		else
			$from = $i * $indexMaxperpage;
		$limit = ( $i == $offset || $i == $stopat ) ? 1 : 2;
		$sql = "SELECT cur_title $fromwhere $order_str " . $dbr->limitResult ( $limit, $from );
		$res = $dbr->query( $sql, $fname );
		$s = $dbr->fetchObject( $res );
		array_push ( $lines, $s->cur_title );
		if ( $s = $dbr->fetchObject( $res ) ) {
			array_push ( $lines, $s->cur_title );
		}
		$dbr->freeResult( $res );
	}

	# At this point, $lines should contain an even number of elements.
	$out .= "<table style='background: inherit;'>";
	while ( count ( $lines ) > 0 ) {
		$inpoint = array_shift ( $lines );
		$outpoint = array_shift ( $lines );
		$out .= indexShowline ( $inpoint, $outpoint, $namespace );
	}
	$out .= "</table>";

	$nsForm = namespaceForm ( $namespace );

	# Is there more?
	$morelinks = "";
	if ( $offset > 0 ) {
		$morelinks = $sk->makeKnownLink (
			$wgContLang->specialPage ( "Allpages" ),
			wfMsg ( 'allpagesprev' ),
			( $offset > $toplevelMaxperpage ) ? 'offset='.($offset-$toplevelMaxperpage) : ''
		);
	}
	if ( $stopat < $sections-1 ) {
		if ( $morelinks != "" ) { $morelinks .= " | "; }
		$morelinks .= $sk->makeKnownLink (
			$wgContLang->specialPage ( "Allpages" ),
			wfMsg ( 'allpagesnext' ),
			'offset=' . ($offset + $toplevelMaxperpage)
		);
	}

	if ( $morelinks != "" ) {
		$out2 = '<table style="background: inherit;" width="100%" cellpadding="0" cellspacing="0" border="0">';
		$out2 .= '<tr valign="top"><td align="left">' . $nsForm;
		$out2 .= '</td><td align="right" style="font-size: smaller; margin-bottom: 1em;">';
		$out2 .= $morelinks . '</td></tr></table><hr />';
	} else {
		$out2 = $nsForm . '<hr />';
	}

	$wgOut->addHtml( $out2 . $out );
}

function indexShowline( $inpoint, $outpoint, $namespace = 0 ) {
	global $wgOut, $wgLang, $wgUser;
	$sk = $wgUser->getSkin();
	$dbr =& wfGetDB( DB_SLAVE );

	$inpointf = htmlspecialchars( str_replace( "_", " ", $inpoint ) );
	$outpointf = htmlspecialchars( str_replace( "_", " ", $outpoint ) );
	$queryparams = $namespace ? ('namespace='.intval($namespace)) : '';
	$special = Title::makeTitle( NS_SPECIAL, 'Allpages/' . $inpoint );
	$link = $special->escapeLocalUrl( $queryparams );
	
	$out = wfMsg(
		'alphaindexline',
		"<a href=\"$link\">$inpointf</a></td><td><a href=\"$link\">",
		"</a></td><td align=\"left\"><a href=\"$link\">$outpointf</a>"
	);
	return '<tr><td align="right">'.$out.'</td></tr>';
}

function indexShowChunk( $from, $namespace = 0 ) {
	global $wgOut, $wgUser, $indexMaxperpage, $wgContLang;
	$sk = $wgUser->getSkin();
	$maxPlusOne = $indexMaxperpage + 1;
	$namespacee = intval($namespace);

	$out = "";
	$dbr =& wfGetDB( DB_SLAVE );
	$cur = $dbr->tableName( 'cur' );
	
	$fromTitle = Title::newFromURL( $from );
	$fromKey = is_null( $fromTitle ) ? '' : $fromTitle->getDBkey();
	
	$sql = "SELECT cur_title FROM $cur WHERE cur_namespace=$namespacee" .
		" AND cur_title >= ".  $dbr->addQuotes( $fromKey ) .
		" ORDER BY cur_title LIMIT " . $maxPlusOne;
	$res = $dbr->query( $sql, "indexShowChunk" );

	### FIXME: side link to previous

	$n = 0;
	$out = '<table style="background: inherit;" border="0" width="100%">';
	while( ($n < $indexMaxperpage) && ($s = $dbr->fetchObject( $res )) ) {
		$t = Title::makeTitle( $namespacee, $s->cur_title );
		if( $t ) {
			$link = $sk->makeKnownLinkObj( $t, $t->getText() );
		} else {
			$link = '[[' . htmlspecialchars( $s->cur_title ) . ']]';
		}
		if( $n % 3 == 0 ) {
			$out .= '<tr>';
		}
		$out .= "<td>$link</td>";
		$n++;
		if( $n % 3 == 0 ) {
			$out .= '</tr>';
		}
	}
	if( ($n % 3) != 0 ) {
		$out .= '</tr>';
	}
	$out .= '</table>';

	$nsForm = namespaceForm ( $namespace, $from );
	$out2 = '<table style="background: inherit;" width="100%" cellpadding="0" cellspacing="0" border="0">';
	$out2 .= '<tr valign="top"><td align="left">' . $nsForm;
	$out2 .= '</td><td align="right" style="font-size: smaller; margin-bottom: 1em;">' .
			$sk->makeKnownLink( $wgContLang->specialPage( "Allpages" ),
				wfMsg ( 'allpages' ) );
	if ( ($n == $indexMaxperpage) && ($s = $dbr->fetchObject( $res )) ) {
		$namespaceparam = $namespace ? "&namespace=$namespace" : "";
		$out2 .= " | " . $sk->makeKnownLink(
			$wgContLang->specialPage( "Allpages" ),
			wfMsg ( 'nextpage', $s->cur_title ),
			"from=" . wfUrlEncode ( $s->cur_title ) . $namespaceparam );
	}
	$out2 .= "</td></tr></table><hr />";

	$wgOut->addHtml( $out2 . $out );
}

?>
