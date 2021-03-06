<?php
/**
 * Contain the EditPage class
 * @package MediaWiki
 */

/**
 * Splitting edit page/HTML interface from Article...
 * The actual database and text munging is still in Article,
 * but it should get easier to call those from alternate
 * interfaces.
 *
 * @package MediaWiki
 */

class EditPage {
	var $mArticle;
	var $mTitle;
	
	# Form values
	var $save = false, $preview = false;
	var $minoredit = false, $watchthis = false;
	var $textbox1 = '', $textbox2 = '', $summary = '';
	var $edittime = '', $section = '';
	var $oldid = 0;
	
	/**
	 * @todo document
	 * @param $article
	 */
	function EditPage( $article ) {
		$this->mArticle =& $article;
		global $wgTitle;
		$this->mTitle =& $wgTitle;
	}

	/**
	 * This is the function that gets called for "action=edit".
	 */
	function edit() {
		global $wgOut, $wgUser, $wgWhitelistEdit, $wgRequest;
		// this is not an article
		$wgOut->setArticleFlag(false);

		$this->importFormData( $wgRequest );

		if ( ! $this->mTitle->userCanEdit() ) {
			$wgOut->readOnlyPage( $this->mArticle->getContent( true ), true );
			return;
		}
		if ( $wgUser->isBlocked() ) {
			$this->blockedIPpage();
			return;
		}
		if ( !$wgUser->getID() && $wgWhitelistEdit ) {
			$this->userNotLoggedInPage();
			return;
		}
		if ( wfReadOnly() ) {
			if( $this->save || $this->preview ) {
				$this->editForm( 'preview' );
			} else {
				$wgOut->readOnlyPage( $this->mArticle->getContent( true ) );
			}
			return;
		}
		if ( $this->save ) {
			$this->editForm( 'save' );
		} else if ( $this->preview ) {
			$this->editForm( 'preview' );
		} else { # First time through
			if( $wgUser->getOption('previewonfirst') ) {
				$this->editForm( 'preview', true );
			} else {
				$this->editForm( 'initial', true );
			}
		}
	}

	/**
	 * @todo document
	 */
	function importFormData( &$request ) {
		if( $request->getVal( 'action' ) == 'submit' && $request->wasPosted() ) {
			# These fields need to be checked for encoding.
			# Also remove trailing whitespace, but don't remove _initial_
			# whitespace from the text boxes. This may be significant formatting.
			$this->textbox1 = rtrim( $request->getText( 'wpTextbox1' ) );
			$this->textbox2 = rtrim( $request->getText( 'wpTextbox2' ) );
			$this->summary  =  trim( $request->getText( 'wpSummary'  ) );
	
			$this->edittime = $request->getVal( 'wpEdittime' );
			if( is_null( $this->edittime ) ) {
				# If the form is incomplete, force to preview.
				$this->preview  = true;
			} else {
				if( $this->tokenOk( $request ) ) {
					# Some browsers will not report any submit button
					# if the user hits enter in the comment box.
					# The unmarked state will be assumed to be a save,
					# if the form seems otherwise complete.
					$this->preview = $request->getCheck( 'wpPreview' );
				} else {
					# Page might be a hack attempt posted from
					# an external site. Preview instead of saving.
					$this->preview = true;
				}
			}
			$this->save    = !$this->preview;
			if( !preg_match( '/^\d{14}$/', $this->edittime )) {
				$this->edittime = null;
			}
	
			$this->minoredit = $request->getCheck( 'wpMinoredit' );
			$this->watchthis = $request->getCheck( 'wpWatchthis' );
		} else {
			# Not a posted form? Start with nothing.
			$this->textbox1  = '';
			$this->textbox2  = '';
			$this->summary   = '';
			$this->edittime  = '';
			$this->preview   = false;
			$this->save      = false;
			$this->minoredit = false;
			$this->watchthis = false;
		}

		$this->oldid = $request->getInt( 'oldid' );

		# Section edit can come from either the form or a link
		$this->section = $request->getVal( 'wpSection', $request->getVal( 'section' ) );
	}

	/**
	 * Make sure the form isn't faking a user's credentials.
	 *
	 * @param WebRequest $request
	 * @return bool
	 * @access private
	 */
	function tokenOk( &$request ) {
		global $wgUser;
		if( $wgUser->getId() == 0 ) {
			# Anonymous users may not have a session
			# open. Don't tokenize.
			return true;
		} else {
			return $wgUser->matchEditToken( $request->getVal( 'wpEditToken' ) );
		}
	}
	
	function submit() {
		$this->edit();
	}

	/**
	 * The edit form is self-submitting, so that when things like
	 * preview and edit conflicts occur, we get the same form back
	 * with the extra stuff added.  Only when the final submission
	 * is made and all is well do we actually save and redirect to
	 * the newly-edited page.
	 *
	 * @param string $formtype Type of form either : save, initial or preview
	 * @param bool $firsttime True to load form data from db
	 */
	function editForm( $formtype, $firsttime = false ) {
		global $wgOut, $wgUser;
		global $wgLang, $wgContLang, $wgParser, $wgTitle;
		global $wgAllowAnonymousMinor;
		global $wgWhitelistEdit;
		global $wgSpamRegex, $wgFilterCallback;
		global $wgUseLatin1;

		$sk = $wgUser->getSkin();
		$isConflict = false;
		// css / js subpages of user pages get a special treatment
		$isCssJsSubpage = (Namespace::getUser() == $wgTitle->getNamespace() and preg_match("/\\.(css|js)$/", $wgTitle->getText() ));

		if(!$this->mTitle->getArticleID()) { # new article
			$wgOut->addWikiText(wfmsg('newarticletext'));
		}

		if( Namespace::isTalk( $this->mTitle->getNamespace() ) ) {
			$wgOut->addWikiText(wfmsg('talkpagetext'));
		}

		# Attempt submission here.  This will check for edit conflicts,
		# and redundantly check for locked database, blocked IPs, etc.
		# that edit() already checked just in case someone tries to sneak
		# in the back door with a hand-edited submission URL.

		if ( 'save' == $formtype ) {
			# Check for spam
			if ( $wgSpamRegex && preg_match( $wgSpamRegex, $this->textbox1, $matches ) ) {
				$this->spamPage ( $matches[0] );
				return;
			}
			if ( $wgFilterCallback && $wgFilterCallback( $this->mTitle, $this->textbox1, $this->section ) ) {
				# Error messages or other handling should be performed by the filter function
				return;
			}
			if ( $wgUser->isBlocked() ) {
				$this->blockedIPpage();
				return;
			}
			if ( !$wgUser->getID() && $wgWhitelistEdit ) {
				$this->userNotLoggedInPage();
				return;
			}
			if ( wfReadOnly() ) {
				$wgOut->readOnlyPage();
				return;
			}
			if ( $wgUser->pingLimiter() ) {
				$wgOut->rateLimited();
				return;
			}

			# If article is new, insert it.
			$aid = $this->mTitle->getArticleID( GAID_FOR_UPDATE );
			if ( 0 == $aid ) {
				# Don't save a new article if it's blank.
				if ( ( '' == $this->textbox1 ) ||
				  ( wfMsg( 'newarticletext' ) == $this->textbox1 ) ) {
					$wgOut->redirect( $this->mTitle->getFullURL() );
					return;
				}
				if (wfRunHooks('ArticleSave', array(&$this->mArticle, &$wgUser, &$this->textbox1,
							   &$this->summary, &$this->minoredit, &$this->watchthis, NULL)))
				{
					$this->mArticle->insertNewArticle( $this->textbox1, $this->summary,
													   $this->minoredit, $this->watchthis );
					wfRunHooks('ArticleSaveComplete', array(&$this->mArticle, &$wgUser, $this->textbox1,
															$this->summary, $this->minoredit,
															$this->watchthis, NULL));
				}
				return;
			}

			# Article exists. Check for edit conflict.

			$this->mArticle->clear(); # Force reload of dates, etc.
			$this->mArticle->forUpdate( true ); # Lock the article

			if( ( $this->section != 'new' ) &&
				($this->mArticle->getTimestamp() != $this->edittime ) ) {
				$isConflict = true;
			}
			$userid = $wgUser->getID();

			if ( $isConflict) {
				$text = $this->mArticle->getTextOfLastEditWithSectionReplacedOrAdded(
					$this->section, $this->textbox1, $this->summary, $this->edittime);
			}
			else {
				$text = $this->mArticle->getTextOfLastEditWithSectionReplacedOrAdded(
					$this->section, $this->textbox1, $this->summary);
			}
			# Suppress edit conflict with self

			if ( ( 0 != $userid ) && ( $this->mArticle->getUser() == $userid ) ) {
				$isConflict = false;
			} else {
				# switch from section editing to normal editing in edit conflict
				if($isConflict) {
					# Attempt merge
					if( $this->mergeChangesInto( $text ) ){
						// Successful merge! Maybe we should tell the user the good news?
						$isConflict = false;
					} else {
						$this->section = '';
						$this->textbox1 = $text;
					}
				}
			}
			if ( ! $isConflict ) {
				# All's well
				$sectionanchor = '';
				if( $this->section == 'new' ) {
					if( $this->summary != '' ) {
						$sectionanchor = $this->sectionAnchor( $this->summary );
					}
				} elseif( $this->section != '' ) {
					# Try to get a section anchor from the section source, redirect to edited section if header found
					# XXX: might be better to integrate this into Article::getTextOfLastEditWithSectionReplacedOrAdded
					# for duplicate heading checking and maybe parsing
					$hasmatch = preg_match( "/^ *([=]{1,6})(.*?)(\\1) *\\n/i", $this->textbox1, $matches );
					# we can't deal with anchors, includes, html etc in the header for now, 
					# headline would need to be parsed to improve this
					#if($hasmatch and strlen($matches[2]) > 0 and !preg_match( "/[\\['{<>]/", $matches[2])) {
					if($hasmatch and strlen($matches[2]) > 0) {
						$sectionanchor = $this->sectionAnchor( $matches[2] );
					}
				}
				
				if (wfRunHooks('ArticleSave', array(&$this->mArticle, &$wgUser, &$text,
													&$this->summary, &$this->minoredit,
													&$this->watchthis, &$sectionanchor)))
				{
					# update the article here
					if($this->mArticle->updateArticle( $text, $this->summary, $this->minoredit,
													   $this->watchthis, '', $sectionanchor ))
					{
						wfRunHooks('ArticleSaveComplete', array(&$this->mArticle, &$wgUser, $text,
																$this->summary, $this->minoredit,
																$this->watchthis, $sectionanchor));
						return;
					}
					else
					  $isConflict = true;
				}
			}
		}
		# First time through: get contents, set time for conflict
		# checking, etc.

		if ( 'initial' == $formtype || $firsttime ) {
			$this->edittime = $this->mArticle->getTimestamp();
			$this->textbox1 = $this->mArticle->getContent( true );
			$this->summary = '';
			$this->proxyCheck();
		}
		$wgOut->setRobotpolicy( 'noindex,nofollow' );

		# Enabled article-related sidebar, toplinks, etc.
		$wgOut->setArticleRelated( true );

		if ( $isConflict ) {
			$s = wfMsg( 'editconflict', $this->mTitle->getPrefixedText() );
			$wgOut->setPageTitle( $s );
			$wgOut->addHTML( wfMsg( 'explainconflict' ) );

			$this->textbox2 = $this->textbox1;
			$this->textbox1 = $this->mArticle->getContent( true );
			$this->edittime = $this->mArticle->getTimestamp();
		} else {

			if( $this->section != '' ) {
				if( $this->section == 'new' ) {
					$s = wfMsg('editingcomment', $this->mTitle->getPrefixedText() );
				} else {
					$s = wfMsg('editingsection', $this->mTitle->getPrefixedText() );
				}
				if(!$this->preview) {
					preg_match( "/^(=+)(.+)\\1/mi",
						$this->textbox1,
						$matches );
					if( !empty( $matches[2] ) ) {
						$this->summary = "/* ". trim($matches[2])." */ ";
					}
				}
			} else {
				$s = wfMsg( 'editing', $this->mTitle->getPrefixedText() );
			}
			$wgOut->setPageTitle( $s );
			if ( !$wgUseLatin1 && !$this->checkUnicodeCompliantBrowser() ) {
				$this->mArticle->setOldSubtitle();
				$wgOut->addWikiText( wfMsg( 'nonunicodebrowser') );
			}
			if ( $this->oldid ) {
				$this->mArticle->setOldSubtitle();
				$wgOut->addHTML( wfMsg( 'editingold' ) );
			}
		}

		if( wfReadOnly() ) {
			$wgOut->addHTML( '<strong>' .
			wfMsg( 'readonlywarning' ) .
			"</strong>" );
		} else if ( $isCssJsSubpage and 'preview' != $formtype) {
			$wgOut->addHTML( wfMsg( 'usercssjsyoucanpreview' ));
		}
		if( $this->mTitle->isProtected('edit') ) {
			$wgOut->addHTML( '<strong>' . wfMsg( 'protectedpagewarning' ) .
			  "</strong><br />\n" );
		}

		$kblength = (int)(strlen( $this->textbox1 ) / 1024);
		if( $kblength > 29 ) {
			$wgOut->addHTML( '<strong>' .
				wfMsg( 'longpagewarning', $wgLang->formatNum( $kblength ) )
				. '</strong>' );
		}

		$rows = $wgUser->getOption( 'rows' );
		$cols = $wgUser->getOption( 'cols' );

		$ew = $wgUser->getOption( 'editwidth' );
		if ( $ew ) $ew = " style=\"width:100%\"";
		else $ew = '';

		$q = 'action=submit';
		#if ( "no" == $redirect ) { $q .= "&redirect=no"; }
		$action = $this->mTitle->escapeLocalURL( $q );

		$summary = wfMsg('summary');
		$subject = wfMsg('subject');
		$minor   = wfMsg('minoredit');
		$watchthis = wfMsg ('watchthis');
		$save = wfMsg('savearticle');
		$prev = wfMsg('showpreview');

		$cancel = $sk->makeKnownLink( $this->mTitle->getPrefixedText(),
				wfMsg('cancel') );
		$edithelpurl = $sk->makeUrl( wfMsg( 'edithelppage' ));
		$edithelp = '<a target="helpwindow" href="'.$edithelpurl.'">'.
			htmlspecialchars( wfMsg( 'edithelp' ) ).'</a> '.
			htmlspecialchars( wfMsg( 'newwindow' ) );

		global $wgRightsText;
		$copywarn = "<div id=\"editpage-copywarn\">\n" .
			wfMsg( $wgRightsText ? 'copyrightwarning' : 'copyrightwarning2',
				'[[' . wfMsg( 'copyrightpage' ) . ']]',
				$wgRightsText ) . "\n</div>";

		if( $wgUser->getOption('showtoolbar') and !$isCssJsSubpage ) {
			# prepare toolbar for edit buttons
			$toolbar = $this->getEditToolbar();
		} else {
			$toolbar = '';
		}

		// activate checkboxes if user wants them to be always active
		if( !$this->preview ) {
			if( $wgUser->getOption( 'watchdefault' ) ) $this->watchthis = true;
			if( $wgUser->getOption( 'minordefault' ) ) $this->minoredit = true;

			// activate checkbox also if user is already watching the page,
			// require wpWatchthis to be unset so that second condition is not
			// checked unnecessarily
			if( !$this->watchthis && $this->mTitle->userIsWatching() ) $this->watchthis = true;
		}

		$minoredithtml = '';

		if ( 0 != $wgUser->getID() || $wgAllowAnonymousMinor ) {
			$minoredithtml =
				"<input tabindex='3' type='checkbox' value='1' name='wpMinoredit'".($this->minoredit?" checked='checked'":"").
				" accesskey='".wfMsg('accesskey-minoredit')."' id='wpMinoredit' />".
				"<label for='wpMinoredit' title='".wfMsg('tooltip-minoredit')."'>{$minor}</label>";
		}

		$watchhtml = '';

		if ( 0 != $wgUser->getID() ) {
			$watchhtml = "<input tabindex='4' type='checkbox' name='wpWatchthis'".($this->watchthis?" checked='checked'":"").
				" accesskey='".wfMsg('accesskey-watch')."' id='wpWatchthis'  />".
				"<label for='wpWatchthis' title='".wfMsg('tooltip-watch')."'>{$watchthis}</label>";
		}

		$checkboxhtml = $minoredithtml . $watchhtml . '<br />';

		if ( 'preview' == $formtype) {
			$previewhead='<h2>' . wfMsg( 'preview' ) . "</h2>\n<p><center><font color=\"#cc0000\">" .
				wfMsg( 'note' ) . wfMsg( 'previewnote' ) . "</font></center></p>\n";
			if ( $isConflict ) {
				$previewhead.='<h2>' . wfMsg( 'previewconflict' ) .
					"</h2>\n";
			}

			$parserOptions = ParserOptions::newFromUser( $wgUser );
			$parserOptions->setEditSection( false );
			$parserOptions->setEditSectionOnRightClick( false );

			# don't parse user css/js, show message about preview
			# XXX: stupid php bug won't let us use $wgTitle->isCssJsSubpage() here

			if ( $isCssJsSubpage ) {
				if(preg_match("/\\.css$/", $wgTitle->getText() ) ) {
					$previewtext = wfMsg('usercsspreview');
				} else if(preg_match("/\\.js$/", $wgTitle->getText() ) ) {
					$previewtext = wfMsg('userjspreview');
				}
				$parserOutput = $wgParser->parse( $previewtext , $wgTitle, $parserOptions );
				$wgOut->addHTML( $parserOutput->mText );
			} else {
				$parserOutput = $wgParser->parse( $this->mArticle->preSaveTransform( $this->textbox1 ) ."\n\n",
						$wgTitle, $parserOptions );		
				
				$previewHTML = $parserOutput->mText;

				if($wgUser->getOption('previewontop')) {
					$wgOut->addHTML($previewhead);
					$wgOut->addHTML($previewHTML);
				}
				$wgOut->addCategoryLinks($parserOutput->getCategoryLinks());
				$wgOut->addLanguageLinks($parserOutput->getLanguageLinks());
				$wgOut->addHTML( "<br style=\"clear:both;\" />\n" );
			}
		}

		# if this is a comment, show a subject line at the top, which is also the edit summary.
		# Otherwise, show a summary field at the bottom
		$summarytext = htmlspecialchars( $wgContLang->recodeForEdit( $this->summary ) ); # FIXME
			if( $this->section == 'new' ) {
				$commentsubject="{$subject}: <input tabindex='1' type='text' value=\"$summarytext\" name=\"wpSummary\" maxlength='200' size='60' /><br />";
				$editsummary = '';
			} else {
				$commentsubject = '';
				$editsummary="{$summary}: <input tabindex='2' type='text' value=\"$summarytext\" name=\"wpSummary\" maxlength='200' size='60' /><br />";
			}

		if( !$this->preview ) {
		# Don't select the edit box on preview; this interferes with seeing what's going on.
			$wgOut->setOnloadHandler( 'document.editform.wpTextbox1.focus()' );
		}
		# Prepare a list of templates used by this page
		$templates = '';
		$id = $this->mTitle->getArticleID();
		if ( 0 !== $id ) {
			$db =& wfGetDB( DB_SLAVE );
			$cur = $db->tableName( 'cur' );
			$links = $db->tableName( 'links' );
			$sql = "SELECT cur_namespace,cur_title,cur_id ".
				"FROM $cur,$links WHERE l_to=cur_id AND l_from={$id} and cur_namespace=".NS_TEMPLATE;
			$res = $db->query( $sql, "EditPage::editform" );
			if ( false !== $res ) {
				if ( $db->numRows( $res ) ) {
					$templates = '<br />'. wfMsg( 'templatesused' ) . '<ul>';
					while ( $row = $db->fetchObject( $res ) ) {
						if ( $titleObj = Title::makeTitle( $row->cur_namespace, $row->cur_title ) ) {
							$templates .= '<li>' . $sk->makeLinkObj( $titleObj ) . '</li>';
						}
					}
					$templates .= '</ul>';
				}
				$db->freeResult( $res );
			}
		}

		$wgOut->addHTML( "
{$toolbar}
<form id=\"editform\" name=\"editform\" method=\"post\" action=\"$action\"
enctype=\"multipart/form-data\">
{$commentsubject}
<textarea tabindex='1' accesskey=\",\" name=\"wpTextbox1\" rows='{$rows}'
cols='{$cols}'{$ew}>" .
htmlspecialchars( $wgContLang->recodeForEdit( $this->textbox1 ) ) .
"
</textarea>
<br />{$editsummary}
{$checkboxhtml}
<input tabindex='5' id='wpSave' type='submit' value=\"{$save}\" name=\"wpSave\" accesskey=\"".wfMsg('accesskey-save')."\"".
" title=\"".wfMsg('tooltip-save')."\"/>
<input tabindex='6' id='wpPreview' type='submit' value=\"{$prev}\" name=\"wpPreview\" accesskey=\"".wfMsg('accesskey-preview')."\"".
" title=\"".wfMsg('tooltip-preview')."\"/>
<em>{$cancel}</em> | <em>{$edithelp}</em>{$templates}" );
		$wgOut->addWikiText( $copywarn );
		$wgOut->addHTML( "
<input type='hidden' value=\"" . htmlspecialchars( $this->section ) . "\" name=\"wpSection\" />
<input type='hidden' value=\"{$this->edittime}\" name=\"wpEdittime\" />\n" );

		if ( 0 != $wgUser->getID() ) {
			/**
			 * To make it harder for someone to slip a user a page
			 * which submits an edit form to the wiki without their
			 * knowledge, a random token is associated with the login
			 * session. If it's not passed back with the submission,
			 * we won't save the page, or render user JavaScript and
			 * CSS previews.
			 */
			$token = htmlspecialchars( $wgUser->editToken() );
			$wgOut->addHTML( "
<input type='hidden' value=\"$token\" name=\"wpEditToken\" />\n" );
		}
		
		if ( $isConflict ) {
			require_once( "DifferenceEngine.php" );
			$wgOut->addHTML( "<h2>" . wfMsg( "yourdiff" ) . "</h2>\n" );
			DifferenceEngine::showDiff( $this->textbox2, $this->textbox1,
			  wfMsg( "yourtext" ), wfMsg( "storedversion" ) );

			$wgOut->addHTML( "<h2>" . wfMsg( "yourtext" ) . "</h2>
<textarea tabindex=6 id='wpTextbox2' name=\"wpTextbox2\" rows='{$rows}' cols='{$cols}' wrap='virtual'>"
. htmlspecialchars( $wgContLang->recodeForEdit( $this->textbox2 ) ) .
"
</textarea>" );
		}
		$wgOut->addHTML( "</form>\n" );
		if($formtype =="preview" && !$wgUser->getOption("previewontop")) {
			$wgOut->addHTML($previewhead);
			$wgOut->addHTML($previewHTML);
		}
	}

	/**
	 * @todo document
	 */
	function blockedIPpage() {
		global $wgOut, $wgUser, $wgContLang, $wgIP;

		$wgOut->setPageTitle( wfMsg( 'blockedtitle' ) );
		$wgOut->setRobotpolicy( 'noindex,nofollow' );
		$wgOut->setArticleRelated( false );

		$id = $wgUser->blockedBy();
		$reason = $wgUser->blockedFor();
		$ip = $wgIP;
		
		if ( is_numeric( $id ) ) {
			$name = User::whoIs( $id );
		} else {
			$name = $id;
		}
		$link = '[[' . $wgContLang->getNsText( Namespace::getUser() ) .
		  ":{$name}|{$name}]]";

		$wgOut->addWikiText( wfMsg( 'blockedtext', $link, $reason, $ip, $name ) );
		$wgOut->returnToMain( false );
	}

	/**
	 * @todo document
	 */
	function userNotLoggedInPage() {
		global $wgOut, $wgUser;

		$wgOut->setPageTitle( wfMsg( 'whitelistedittitle' ) );
		$wgOut->setRobotpolicy( 'noindex,nofollow' );
		$wgOut->setArticleRelated( false );

		$wgOut->addWikiText( wfMsg( 'whitelistedittext' ) );
		$wgOut->returnToMain( false );
	}

	/**
	 * @todo document
	 */
	function spamPage ( $match = false )
	{
		global $wgOut;
		$wgOut->setPageTitle( wfMsg( 'spamprotectiontitle' ) );
		$wgOut->setRobotpolicy( 'noindex,nofollow' );
		$wgOut->setArticleRelated( false );

		$wgOut->addWikiText( wfMsg( 'spamprotectiontext' ) );
		if ( $match ) {
			$wgOut->addWikiText( wfMsg( 'spamprotectionmatch', "<nowiki>{$match}</nowiki>" ) );
		}
		$wgOut->returnToMain( false );
	}

	/**
	 * Forks processes to scan the originating IP for an open proxy server
	 * MemCached can be used to skip IPs that have already been scanned
	 */
	function proxyCheck() {
		global $wgBlockOpenProxies, $wgProxyPorts, $wgProxyScriptPath;
		global $wgIP, $wgUseMemCached, $wgMemc, $wgDBname, $wgProxyMemcExpiry;
		
		if ( !$wgBlockOpenProxies ) {
			return;
		}
		
		# Get MemCached key
		$skip = false;
		if ( $wgUseMemCached ) {
			$mcKey = $wgDBname.':proxy:ip:'.$wgIP;
			$mcValue = $wgMemc->get( $mcKey );
			if ( $mcValue ) {
				$skip = true;
			}
		}

		# Fork the processes
		if ( !$skip ) {
			$title = Title::makeTitle( NS_SPECIAL, 'Blockme' );
			$iphash = md5( $wgIP . $wgProxyKey );
			$url = $title->getFullURL( 'ip='.$iphash );

			foreach ( $wgProxyPorts as $port ) {
				$params = implode( ' ', array(
							escapeshellarg( $wgProxyScriptPath ),
							escapeshellarg( $wgIP ),
							escapeshellarg( $port ),
							escapeshellarg( $url )
							));
				exec( "php $params &>/dev/null &" );
			}
			# Set MemCached key
			if ( $wgUseMemCached ) {
				$wgMemc->set( $mcKey, 1, $wgProxyMemcExpiry );
			}
		}
	}

	/**
	 * @access private
	 * @todo document
	 */
	function mergeChangesInto( &$text ){
		$fname = 'EditPage::mergeChangesInto';
		$oldDate = $this->edittime;
		$dbw =& wfGetDB( DB_MASTER );
		$obj = $dbw->selectRow( 'cur', array( 'cur_text' ), array( 'cur_id' => $this->mTitle->getArticleID() ), 
			$fname, 'FOR UPDATE' );

		$yourtext = $obj->cur_text;
		$ns = $this->mTitle->getNamespace();
		$title = $this->mTitle->getDBkey();
		$obj = $dbw->selectRow( 'old', 
			array( 'old_text','old_flags'), 
			array( 'old_namespace' => $ns, 'old_title' => $title, 
				'old_timestamp' => $dbw->timestamp($oldDate)),
			$fname );
		$oldText = Article::getRevisionText( $obj );
		
		if(wfMerge($oldText, $text, $yourtext, $result)){
			$text = $result;
			return true;
		} else {
			return false;
		}
	}


	function checkUnicodeCompliantBrowser() {
		global $wgBrowserBlackList;
		$currentbrowser = $_SERVER["HTTP_USER_AGENT"];
		foreach ( $wgBrowserBlackList as $browser ) {
			if ( preg_match($browser, $currentbrowser) ) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Format an anchor fragment as it would appear for a given section name
	 * @param string $text
	 * @return string
	 * @access private
	 */
	function sectionAnchor( $text ) {
		global $wgInputEncoding;
		$headline = do_html_entity_decode( $text, ENT_COMPAT, $wgInputEncoding );
		# strip out HTML 
		$headline = preg_replace( '/<.*?' . '>/', '', $headline );
		$headline = trim( $headline );
		$sectionanchor = '#' . urlencode( str_replace( ' ', '_', $headline ) );
		$replacearray = array(
			'%3A' => ':',
			'%' => '.'
		);
		return str_replace(
			array_keys( $replacearray ),
			array_values( $replacearray ),
			$sectionanchor );
	}

	/**
	 * Shows a bulletin board style toolbar for common editing functions.
	 * It can be disabled in the user preferences.
	 * The necessary JavaScript code can be found in style/wikibits.js.
	 */
	function getEditToolbar() {
		global $wgStylePath, $wgLang, $wgMimeType;

		/**
		 * toolarray an array of arrays which each include the filename of
		 * the button image (without path), the opening tag, the closing tag,
		 * and optionally a sample text that is inserted between the two when no
		 * selection is highlighted.
		 * The tip text is shown when the user moves the mouse over the button.
		 *
		 * Already here are accesskeys (key), which are not used yet until someone
		 * can figure out a way to make them work in IE. However, we should make
		 * sure these keys are not defined on the edit page.
		 */
		$toolarray=array(
			array(	'image'=>'button_bold.png',
					'open'	=>	"\'\'\'",
					'close'	=>	"\'\'\'",
					'sample'=>	wfMsg('bold_sample'),
					'tip'	=>	wfMsg('bold_tip'),
					'key'	=>	'B'
				),
			array(	'image'=>'button_italic.png',
					'open'	=>	"\'\'",
					'close'	=>	"\'\'",
					'sample'=>	wfMsg('italic_sample'),
					'tip'	=>	wfMsg('italic_tip'),
					'key'	=>	'I'
				),
			array(	'image'=>'button_link.png',
					'open'	=>	'[[',
					'close'	=>	']]',
					'sample'=>	wfMsg('link_sample'),
					'tip'	=>	wfMsg('link_tip'),
					'key'	=>	'L'
				),
			array(	'image'=>'button_extlink.png',
					'open'	=>	'[',
					'close'	=>	']',
					'sample'=>	wfMsg('extlink_sample'),
					'tip'	=>	wfMsg('extlink_tip'),
					'key'	=>	'X'
				),
			array(	'image'=>'button_headline.png',
					'open'	=>	"\\n== ",
					'close'	=>	" ==\\n",
					'sample'=>	wfMsg('headline_sample'),
					'tip'	=>	wfMsg('headline_tip'),
					'key'	=>	'H'
				),
			array(	'image'=>'button_image.png',
					'open'	=>	'[['.$wgLang->getNsText(NS_IMAGE).":",
					'close'	=>	']]',
					'sample'=>	wfMsg('image_sample'),
					'tip'	=>	wfMsg('image_tip'),
					'key'	=>	'D'
				),
			array(	'image'	=>	'button_media.png',
					'open'	=>	'[['.$wgLang->getNsText(NS_MEDIA).':',
					'close'	=>	']]',
					'sample'=>	wfMsg('media_sample'),
					'tip'	=>	wfMsg('media_tip'),
					'key'	=>	'M'
				),
			array(	'image'	=>	'button_math.png',
					'open'	=>	"\\<math\\>",
					'close'	=>	"\\</math\\>",
					'sample'=>	wfMsg('math_sample'),
					'tip'	=>	wfMsg('math_tip'),
					'key'	=>	'C'
				),
			array(	'image'	=>	'button_nowiki.png',
					'open'	=>	"\\<nowiki\\>",
					'close'	=>	"\\</nowiki\\>",
					'sample'=>	wfMsg('nowiki_sample'),
					'tip'	=>	wfMsg('nowiki_tip'),
					'key'	=>	'N'
				),
			array(	'image'	=>	'button_sig.png',
					'open'	=>	'--~~~~',
					'close'	=>	'',
					'sample'=>	'',
					'tip'	=>	wfMsg('sig_tip'),
					'key'	=>	'Y'
				),
			array(	'image'	=>	'button_hr.png',
					'open'	=>	"\\n----\\n",
					'close'	=>	'',
					'sample'=>	'',
					'tip'	=>	wfMsg('hr_tip'),
					'key'	=>	'R'
				)
		);
		$toolbar ="<script type='text/javascript'>\n/*<![CDATA[*/\n";

		$toolbar.="document.writeln(\"<div id='toolbar'>\");\n";
		foreach($toolarray as $tool) {

			$image=$wgStylePath.'/common/images/'.$tool['image'];
			$open=$tool['open'];
			$close=$tool['close'];
			$sample = addslashes( $tool['sample'] );

			// Note that we use the tip both for the ALT tag and the TITLE tag of the image.
			// Older browsers show a "speedtip" type message only for ALT.
			// Ideally these should be different, realistically they
			// probably don't need to be.
			$tip = addslashes( $tool['tip'] );

			#$key = $tool["key"];

			$toolbar.="addButton('$image','$tip','$open','$close','$sample');\n";
		}

		$toolbar.="addInfobox('" . addslashes( wfMsg( "infobox" ) ) . "','" . addslashes(wfMsg("infobox_alert")) . "');\n";
		$toolbar.="document.writeln(\"</div>\");\n";

		$toolbar.="/*]]>*/\n</script>";
		return $toolbar;
	}

}

?>
