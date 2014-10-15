<?php
	//The bbcode parser comes from http://www.christian-seiler.de/projekte/php/bbcode/

  //Setup the bbcode parser
  $bbcode = new BBCode();

  function do_bbcode_url ($tag_name, $attrs, $elem_contents, $func_param, $openclose) {
    // Tag hatte nicht das default-Attribut
    if ($openclose == 'all') {
    		//Fix email addresses
        if (substr($elem_contents, 0, 7) == "mailto:") {
        	  $mail = substr($elem_contents, 7);
            return hidemail($mail, $mail);
        }

        $url = $elem_contents;
        $ltext = htmlspecialchars($elem_contents);
        return '<a href="'.$url.'">'.$ltext.'</a>';
        // Tag hatte das default-Attribut und das hier ist der öffnende Tag
    } else if ($openclose == 'open') {
        return '<a href="'.$attrs['default'].'">';
    // Tag hatte das default-Attribut und das hier ist der schließende Tag
    } else if ($openclose == 'close') {
        return '</a>';
    // Irgendwas seltsames geht vor sich
    } else {
        // Fehler
        return false;
    }
  }

	function bbcode_stripcontents ($text) {
	    return preg_replace ("/[^\n]/", '', $text);
	}

	function bbcode_striplastlinebreak ($text) {
	    $text = preg_replace ("/\n( +)?$/", '$1', $text);
	    return $text;
	}

  function bbcode_fixsize($tagname, $params, $content, $cbparam, $openclose) {
  	if ($openclose == "open")
    	return '<span style="font-size: ' . $params['default'] . 'px">';
    else
    	return '</span>';
  }

  $bbcode->addParser ('htmlspecialchars', array ('block', 'inline', 'link', 'listitem'));
  $bbcode->addParser ('nl2br', array ('block', 'inline', 'link', 'listitem'));

  $bbcode->addParser ('bbcode_striplastlinebreak', 'listitem');
  $bbcode->addParser ('bbcode_stripcontents', array ('list'));

  $bbcode->addCode ('b', 'simple_replace', null, array ('<b>', '</b>'),
                    'inline', array ('block', 'inline', 'link'), array ());
  $bbcode->addCode ('i', 'simple_replace', null, array ('<i>', '</i>'),
                    'inline', array ('block', 'inline', 'link'), array ());
  $bbcode->addCode ('url', 'usecontent?', 'do_bbcode_url', array ('default'),
                    'link', array ('block', 'inline'), array ('link'));

	//Försöker göra en egen :)
	$bbcode->addCode('size',								//Namn på taggen
    'callback_replace',										//Typ av tag
    'bbcode_fixsize',											//Funktion som anropas
    42,																		//Skickas med till callback?
    'inline',																//ingen aning
    array('block', 'inline', 'link'),			//vilka den får finnas i
    array (''));													//vilka den inte får finnas i. kanske

  // Codes hinzufügen
  $bbcode->addCode ('list', 'simple_replace', null, array ('<ul>', '</ul>'),
                    'list', array ('block', 'listitem'), array ());
  $bbcode->addCode ('*', 'simple_replace', null, array ('<li>', "</li>\n"),
                    'listitem', array ('list'), array ());

  // Dieser Code wird nicht geschlossen
  $bbcode->setCodeFlag ('*', 'no_close_tag', true);
?>