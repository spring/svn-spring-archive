<?php
/**
 *
 * @package MediaWiki
 */

/**
 * Various globals
 */
define( 'RC_EDIT', 0);
define( 'RC_NEW', 1);
define( 'RC_MOVE', 2);
define( 'RC_LOG', 3);
define( 'RC_MOVE_OVER_REDIRECT', 4);


/**
 * Utility class for creating new RC entries
 * mAttribs:
 * 	rc_id           id of the row in the recentchanges table
 * 	rc_timestamp    time the entry was made
 * 	rc_cur_time     timestamp on the cur row
 * 	rc_namespace    namespace #
 * 	rc_title        non-prefixed db key
 * 	rc_type         is new entry, used to determine whether updating is necessary
 * 	rc_minor        is minor
 * 	rc_cur_id       id of associated cur entry
 * 	rc_user	        user id who made the entry
 * 	rc_user_text    user name who made the entry
 * 	rc_comment      edit summary
 * 	rc_this_oldid   old_id associated with this entry (or zero)
 * 	rc_last_oldid   old_id associated with the entry before this one (or zero)
 * 	rc_bot          is bot, hidden
 * 	rc_ip           IP address of the user in dotted quad notation
 * 	rc_new          obsolete, use rc_type==RC_NEW
 * 	rc_patrolled    boolean whether or not someone has marked this edit as patrolled
 * 
 * mExtra:
 * 	prefixedDBkey   prefixed db key, used by external app via msg queue
 * 	lastTimestamp   timestamp of previous entry, used in WHERE clause during update
 * 	lang            the interwiki prefix, automatically set in save()
 *  oldSize         text size before the change
 *  newSize         text size after the change
 * 
 * @todo document functions and variables
 * @package MediaWiki
 */
class RecentChange
{
	var $mAttribs = array(), $mExtra = array();
	var $mTitle = false, $mMovedToTitle = false;

	# Factory methods

	/* static */ function newFromRow( $row )
	{
		$rc = new RecentChange;
		$rc->loadFromRow( $row );
		return $rc;
	}

	/* static */ function newFromCurRow( $row )
	{
		$rc = new RecentChange;
		$rc->loadFromCurRow( $row );
		return $rc;
	}

	# Accessors

	function setAttribs( $attribs )
	{
		$this->mAttribs = $attribs;
	}

	function setExtra( $extra )
	{
		$this->mExtra = $extra;
	}

	function &getTitle()
	{
		if ( $this->mTitle === false ) {
			$this->mTitle = Title::makeTitle( $this->mAttribs['rc_namespace'], $this->mAttribs['rc_title'] );
		}
		return $this->mTitle;
	}

	function getMovedToTitle()
	{
		if ( $this->mMovedToTitle === false ) {
			$this->mMovedToTitle = Title::makeTitle( $this->mAttribs['rc_moved_to_ns'],
				$this->mAttribs['rc_moved_to_title'] );
		}
		return $this->mMovedToTitle;
	}

	# Writes the data in this object to the database
	function save()
	{
		global $wgLocalInterwiki, $wgPutIPinRC, $wgRC2UDPAddress, $wgRC2UDPPort, $wgRC2UDPPrefix;
		$fname = 'RecentChange::save';

		$dbw =& wfGetDB( DB_MASTER );
		if ( !is_array($this->mExtra) ) {
			$this->mExtra = array();
		}
		$this->mExtra['lang'] = $wgLocalInterwiki;

		if ( !$wgPutIPinRC ) {
			$this->mAttribs['rc_ip'] = '';
		}

		# Fixup database timestamps
		$this->mAttribs['rc_timestamp']=$dbw->timestamp($this->mAttribs['rc_timestamp']);
		$this->mAttribs['rc_cur_time']=$dbw->timestamp($this->mAttribs['rc_cur_time']);

		# Insert new row
		$dbw->insert( 'recentchanges', $this->mAttribs, $fname );

		# Update old rows, if necessary
		if ( $this->mAttribs['rc_type'] == RC_EDIT ) {
			$oldid = $this->mAttribs['rc_last_oldid'];
			$ns = $this->mAttribs['rc_namespace'];
			$title = $this->mAttribs['rc_title'];
			$lastTime = $this->mExtra['lastTimestamp'];
			$now = $this->mAttribs['rc_timestamp'];
			$curId = $this->mAttribs['rc_cur_id'];

			# Don't bother looking for entries that have probably
			# been purged, it just locks up the indexes needlessly.
			global $wgRCMaxAge;
			$age = time() - wfTimestamp( TS_UNIX, $lastTime );
			if( $age < $wgRCMaxAge ) {
				# Update rc_this_oldid for the entries which were current
				$dbw->update( 'recentchanges',
					array( /* SET */
						'rc_this_oldid' => $oldid
					), array( /* WHERE */
						'rc_namespace' => $ns,
						'rc_title' => $title,
						'rc_timestamp' => $dbw->timestamp( $lastTime )
					), $fname
				);
			}

			# Update rc_cur_time
			$dbw->update( 'recentchanges', array( 'rc_cur_time' => $now ),
				array( 'rc_cur_id' => $curId ), $fname );
		}

		# Notify external application via UDP
		if ( $wgRC2UDPAddress ) {
			$conn = socket_create( AF_INET, SOCK_DGRAM, SOL_UDP );
			if ( $conn ) {
				$line = $wgRC2UDPPrefix . $this->getIRCLine();
				socket_sendto( $conn, $line, strlen($line), 0, $wgRC2UDPAddress, $wgRC2UDPPort );
				socket_close( $conn );
			}
		}
	}

	# Marks a certain row as patrolled
	function markPatrolled( $rcid )
	{
		$fname = 'RecentChange::markPatrolled';

		$dbw =& wfGetDB( DB_MASTER );

		$dbw->update( 'recentchanges',
			array( /* SET */
				'rc_patrolled' => 1
			), array( /* WHERE */
				'rc_id' => $rcid
			), $fname
		);
	}

	# Makes an entry in the database corresponding to an edit
	/*static*/ function notifyEdit( $timestamp, &$title, $minor, &$user, $comment,
		$oldId, $lastTimestamp, $bot = "default", $ip = '', $oldSize = 0, $newSize = 0 )
	{
		if ( $bot == 'default ' ) {
			$bot = $user->isBot();
		}

		if ( !$ip ) {
			global $wgIP;
			$ip = empty( $wgIP ) ? '' : $wgIP;
		}

		$rc = new RecentChange;
		$rc->mAttribs = array(
			'rc_timestamp'	=> $timestamp,
			'rc_cur_time'	=> $timestamp,
			'rc_namespace'	=> $title->getNamespace(),
			'rc_title'	=> $title->getDBkey(),
			'rc_type'	=> RC_EDIT,
			'rc_minor'	=> $minor ? 1 : 0,
			'rc_cur_id'	=> $title->getArticleID(),
			'rc_user'	=> $user->getID(),
			'rc_user_text'	=> $user->getName(),
			'rc_comment'	=> $comment,
			'rc_this_oldid'	=> 0,
			'rc_last_oldid'	=> $oldId,
			'rc_bot'	=> $bot ? 1 : 0,
			'rc_moved_to_ns'	=> 0,
			'rc_moved_to_title'	=> '',
			'rc_ip'	=> $ip,
			'rc_patrolled' => 0,
			'rc_new'	=> 0 # obsolete
		);

		$rc->mExtra =  array(
			'prefixedDBkey'	=> $title->getPrefixedDBkey(),
			'lastTimestamp' => $lastTimestamp,
			'oldSize'       => $oldSize,
			'newSize'       => $newSize,
		);
		$rc->save();
	}

	# Makes an entry in the database corresponding to page creation
	# Note: the title object must be loaded with the new id using resetArticleID()
	/*static*/ function notifyNew( $timestamp, &$title, $minor, &$user, $comment, $bot = "default", 
	  $ip='', $size = 0 )
	{
		if ( !$ip ) {
			global $wgIP;
			$ip = empty( $wgIP ) ? '' : $wgIP;
		}
		if ( $bot == 'default' ) {
			$bot = $user->isBot();
		}

		$rc = new RecentChange;
		$rc->mAttribs = array(
			'rc_timestamp'      => $timestamp,
			'rc_cur_time'       => $timestamp,
			'rc_namespace'      => $title->getNamespace(),
			'rc_title'          => $title->getDBkey(),
			'rc_type'           => RC_NEW,
			'rc_minor'          => $minor ? 1 : 0,
			'rc_cur_id'         => $title->getArticleID(),
			'rc_user'           => $user->getID(),
			'rc_user_text'      => $user->getName(),
			'rc_comment'        => $comment,
			'rc_this_oldid'     => 0,
			'rc_last_oldid'     => 0,
			'rc_bot'            => $bot ? 1 : 0,
			'rc_moved_to_ns'    => 0,
			'rc_moved_to_title' => '',
			'rc_ip'             => $ip,
			'rc_patrolled'      => 0,
			'rc_new'	=> 1 # obsolete
		);

		$rc->mExtra =  array(
			'prefixedDBkey'	=> $title->getPrefixedDBkey(),
			'lastTimestamp' => 0,
			'oldSize' => 0,
			'newSize' => $size
		);
		$rc->save();
	}

	# Makes an entry in the database corresponding to a rename
	/*static*/ function notifyMove( $timestamp, &$oldTitle, &$newTitle, &$user, $comment, $ip='', $overRedir = false )
	{
		if ( !$ip ) {
			global $wgIP;
			$ip = empty( $wgIP ) ? '' : $wgIP;
		}
		$rc = new RecentChange;
		$rc->mAttribs = array(
			'rc_timestamp'	=> $timestamp,
			'rc_cur_time'	=> $timestamp,
			'rc_namespace'	=> $oldTitle->getNamespace(),
			'rc_title'	=> $oldTitle->getDBkey(),
			'rc_type'	=> $overRedir ? RC_MOVE_OVER_REDIRECT : RC_MOVE,
			'rc_minor'	=> 0,
			'rc_cur_id'	=> $oldTitle->getArticleID(),
			'rc_user'	=> $user->getID(),
			'rc_user_text'	=> $user->getName(),
			'rc_comment'	=> $comment,
			'rc_this_oldid'	=> 0,
			'rc_last_oldid'	=> 0,
			'rc_bot'	=> $user->isBot() ? 1 : 0,
			'rc_moved_to_ns'	=> $newTitle->getNamespace(),
			'rc_moved_to_title'	=> $newTitle->getDBkey(),
			'rc_ip'		=> $ip,
			'rc_new'	=> 0, # obsolete
			'rc_patrolled' => 1
		);

		$rc->mExtra = array(
			'prefixedDBkey'	=> $oldTitle->getPrefixedDBkey(),
			'lastTimestamp' => 0,
			'prefixedMoveTo'	=> $newTitle->getPrefixedDBkey(),
		);
		$rc->save();
	}

	/* static */ function notifyMoveToNew( $timestamp, &$oldTitle, &$newTitle, &$user, $comment, $ip='' ) {
		RecentChange::notifyMove( $timestamp, $oldTitle, $newTitle, $user, $comment, $ip, false );
	}

	/* static */ function notifyMoveOverRedirect( $timestamp, &$oldTitle, &$newTitle, &$user, $comment, $ip='' ) {
		RecentChange::notifyMove( $timestamp, $oldTitle, $newTitle, $user, $comment, $ip='', true );
	}

	# A log entry is different to an edit in that previous revisions are
	# not kept
	/*static*/ function notifyLog( $timestamp, &$title, &$user, $comment, $ip='' )
	{
		if ( !$ip ) {
			global $wgIP;
			$ip = empty( $wgIP ) ? '' : $wgIP;
		}
		$rc = new RecentChange;
		$rc->mAttribs = array(
			'rc_timestamp'	=> $timestamp,
			'rc_cur_time'	=> $timestamp,
			'rc_namespace'	=> $title->getNamespace(),
			'rc_title'	=> $title->getDBkey(),
			'rc_type'	=> RC_LOG,
			'rc_minor'	=> 0,
			'rc_cur_id'	=> $title->getArticleID(),
			'rc_user'	=> $user->getID(),
			'rc_user_text'	=> $user->getName(),
			'rc_comment'	=> $comment,
			'rc_this_oldid'	=> 0,
			'rc_last_oldid'	=> 0,
			'rc_bot'	=> 0,
			'rc_moved_to_ns'	=> 0,
			'rc_moved_to_title'	=> '',
			'rc_ip'	=> $ip,
			'rc_patrolled' => 1,
			'rc_new'	=> 0 # obsolete
		);
		$rc->mExtra =  array(
			'prefixedDBkey'	=> $title->getPrefixedDBkey(),
			'lastTimestamp' => 0,
		);
		$rc->save();
	}

	# Initialises the members of this object from a mysql row object
	function loadFromRow( $row )
	{
		$this->mAttribs = get_object_vars( $row );
		$this->mExtra = array();
	}

	# Makes a pseudo-RC entry from a cur row, for watchlists and things
	function loadFromCurRow( $row )
	{
		$this->mAttribs = array(
			'rc_timestamp' => $row->cur_timestamp,
			'rc_cur_time' => $row->cur_timestamp,
			'rc_user' => $row->cur_user,
			'rc_user_text' => $row->cur_user_text,
			'rc_namespace' => $row->cur_namespace,
			'rc_title' => $row->cur_title,
			'rc_comment' => $row->cur_comment,
			'rc_minor' => !!$row->cur_minor_edit,
			'rc_type' => $row->cur_is_new ? RC_NEW : RC_EDIT,
			'rc_cur_id' => $row->cur_id,
			'rc_this_oldid'	=> 0,
			'rc_last_oldid'	=> 0,
			'rc_bot'	=> 0,
			'rc_moved_to_ns'	=> 0,
			'rc_moved_to_title'	=> '',
			'rc_ip' => '',
			'rc_patrolled' => '1',  # we can't support patrolling on the Watchlist
			                        # currently because it uses cur, not recentchanges
			'rc_new' => $row->cur_is_new # obsolete
		);

		$this->mExtra = array();
	}


	/**
	 * Gets the end part of the diff URL assoicated with this object
	 * Blank if no diff link should be displayed
	 */
	function diffLinkTrail( $forceCur )
	{
		if ( $this->mAttribs['rc_type'] == RC_EDIT ) {
			$trail = "curid=" . (int)($this->mAttribs['rc_cur_id']) .
				"&oldid=" . (int)($this->mAttribs['rc_last_oldid']);
			if ( $forceCur ) {
				$trail .= '&diff=0' ;
			} else {
				$trail .= '&diff=' . (int)($this->mAttribs['rc_this_oldid']);
			}
		} else {
			$trail = '';
		}
		return $trail;
	}

	function getIRCLine() {
		extract($this->mAttribs);
		extract($this->mExtra);

		$titleObj =& $this->getTitle();
		
		$bad = array("\n", "\r");
		$empty = array("", "");	
		$title = $titleObj->getPrefixedText();
		$title = str_replace($bad, $empty, $title);
		
		if ( $rc_new ) {
			$url = $titleObj->getFullURL();
		} else {
			$url = $titleObj->getFullURL("diff=0&oldid=$rc_last_oldid");
		}

		if ( isset( $oldSize ) && isset( $newSize ) ) {
			$szdiff = $newSize - $oldSize;
			if ($szdiff < -500)
				$szdiff = "\002$szdiff\002";
			else if ($szdiff >= 0)
				$szdiff = "+$szdiff";
			$szdiff = "($szdiff)";
		} else {
			$szdiff = '';
		}

		$comment = str_replace($bad, $empty, $rc_comment);
		$user = str_replace($bad, $empty, $rc_user_text);
		$flag = ($rc_minor ? "M" : "") . ($rc_new ? "N" : "");
		# see http://www.irssi.org/?page=docs&doc=formats for some colour codes. prefix is \003, 
		# no colour (\003) switches back to the term default
		$comment = preg_replace("/\/\* (.*) \*\/(.*)/", "\00315\$1\003 - \00310\$2\003", $comment);
		$fullString = "\00314[[\00307$title\00314]]\0034 $flag\00310 " .
		              "\00302$url\003 \0035*\003 \00303$user\003 \0035*\003 $szdiff \00310$comment\003\n";

		return $fullString;
	}
}
?>
