<?php
/** Czech (česky)
 *
 * @package MediaWiki
 * @subpackage Language
 */

require_once( 'LanguageUtf8.php' );

# See Language.php for notes.

if($wgMetaNamespace === FALSE)
        $wgMetaNamespace = str_replace( ' ', '_', $wgSitename );

# Yucky hardcoding hack
switch( $wgMetaNamespace ) {
case 'Wikipedie':
	$wgUserNamespace = 'Wikipedista'; break;
case 'Wikcionář':
	$wgUserNamespace = 'Wikcionarista'; break;
default:
	$wgUserNamespace = 'Uživatel';
}

/* private */ $wgNamespaceNamesCs = array(
        NS_MEDIA              => 'Média',
        NS_SPECIAL            => 'Speciální',
        NS_MAIN               => '',
        NS_TALK               => 'Diskuse',
        NS_USER               => $wgUserNamespace,
        NS_USER_TALK          => $wgUserNamespace . '_diskuse',
        NS_PROJECT            => $wgMetaNamespace,
        NS_PROJECT_TALK	      => $wgMetaNamespace . '_diskuse',
        NS_IMAGE              => 'Soubor',
        NS_IMAGE_TALK         => 'Soubor_diskuse',
        NS_MEDIAWIKI          => 'MediaWiki',
        NS_MEDIAWIKI_TALK     => 'MediaWiki_diskuse',
        NS_TEMPLATE           => 'Šablona',
        NS_TEMPLATE_TALK      => 'Šablona_diskuse',
        NS_HELP               => 'Nápověda',
        NS_HELP_TALK          => 'Nápověda_diskuse',
        NS_CATEGORY           => 'Kategorie',
        NS_CATEGORY_TALK      => 'Kategorie_diskuse',
) + $wgNamespaceNamesEn;

/* private */ $wgQuickbarSettingsCs = array(
        'Žádný', 'Leží vlevo', 'Leží vpravo', 'Visí vlevo'
);

/* private */ $wgSkinNamesCs = array(
        'standard'            => 'Standard',
        'nostalgia'           => 'Nostalgie',
        'cologneblue'         => 'Kolínská modř',
        'chick'               => 'Kuře'
) + $wgSkinNamesEn;

# Validation types
$wgValidationTypesCs = array (
	'0' => 'Styl|Příšerný|Nádherný|5',
	'1' => 'Legalita|Ilegální|Legální|5',
	'2' => 'Úplnost|Pahýl|Rozsáhlý|5',
	'3' => 'Fakta|Divoké tipy|Dokonale podložené|5',
	'4' => 'Vhodné pro 1.0 (tisk)|Ne|Ano|2',
	'5' => 'Vhodné pro 1.0 (CD)|Ne|Ano|2'
);

# Hledání knihy podle ISBN
# $wgBookstoreListCs = ..
/* private */ $wgBookstoreListCs = array(
    'Národní knihovna'			=> 'http://sigma.nkp.cz/F/?func=find-a&find_code=ISN&request=$1',
    'Státní technická knihovna' => 'http://www.stk.cz/cgi-bin/dflex/CZE/STK/BROWSE?A=01&V=$1'
) + $wgBookstoreListEn;


# *Neměnit jména v levém sloupci, jsou to interní jména programových
# funkcí. Pravý sloupec  obsahuje několik mezer, které mají tak zůstat,
# aby se tyto funkce nezařadily do seznamu speciálních stránek.

/* private */ $wgValidSpecialPagesCs = array(
  'Userlogin'           => 'Přihlásit se',
  'Userlogout'          => 'Odhlásit se',
  'Preferences'         => 'Nastavení',
  'Watchlist'           => 'Sledované stránky',
  'Recentchanges'       => 'Poslední změny',
  'Upload'              => 'Načíst soubor',
  'Imagelist'           => 'Seznam načtených souborů',
  'Listusers'           => 'Uživatelé',
  'Statistics'          => 'Statistika',
  'Randompage'          => 'Náhodná stránka',

# todo
  'Lonelypages'         => 'Sirotčí články',
  'Unusedimages'        => 'Nepoužívané obrázky a soubory',
  'Popularpages'        => 'Nejnavštěvovanější stránky',
  'Wantedpages'         => 'Žádoucí články',
  'Shortpages'          => 'Nejkratší články',
  'Longpages'           => 'Nejdelší články',
  'Newpages'            => 'Nejnovější články',
  'Ancientpages'        => 'Nejdéle needitované články',
  'Intl'                => 'Mezijazykové odkazy',
  'Allpages'            => 'Všechny stránky',

  'Ipblocklist'         => 'Seznam blokovaných IP adres',
  'Maintenance'         => 'Nástroje pro opravy a údržbu',
  'Specialpages'        => 'Speciální stránky',
  'Contributions'       => 'Příspěvky uživatele',
  'Emailuser'           => 'Poslat e-mail',
  'Whatlinkshere'       => 'Odkazuje sem',
  'Recentchangeslinked' => 'Související změny',
  'Movepage'            => 'Přesunout stránku',
  'Booksources'         => 'Zdroje knih',
  'Categories'          => 'Kategorie',
  'Export'              => 'Exportovat stránky',
  'Version'             => 'Verze',
);

/* private */ $wgSysopSpecialPagesCs = array(
  'Blockip'             => 'Zablokovat uživatele',
  'Asksql'              => 'Dotaz pomocí SQL',
  'Undelete'            => 'Obnovit smazanou stránku'
);

/* private */ $wgDeveloperSpecialPagesCs = array(
  'Lockdb'              => 'Zamknout databázi',
  'Unlockdb'            => 'Odemknout databázi',
  'Debug'               => 'Zobrazit ladící informace'
);

# Note to translators:
#   Please include the English words as synonyms.  This allows people
#   from other wikis to contribute more easily.
#
# Nepoužívá se, pro používání je třeba povolit getMagicWords dole v LanguageCs.
#/* private */ $wgMagicWordsCs = array(
##   ID                                 CASE  SYNONYMS
#    MAG_REDIRECT             => array( 0,    '#redirect',        '#přesměruj'     ),
#    MAG_NOTOC                => array( 0,    '__NOTOC__',        '__BEZOBSAHU__'  ),
#    MAG_FORCETOC             => array( 0,    '__FORCETOC__',     '__VŽDYOBSAH__'  ),
#    MAG_TOC                  => array( 0,    '__TOC__',          '__OBSAH__'      ),
#    MAG_NOEDITSECTION        => array( 0,    '__NOEDITSECTION__', '__BEZEDITOVATČÁST__' ),
#    MAG_START                => array( 0,    '__START__',        '__ZAČÁTEK__'        ),
#    MAG_CURRENTMONTH         => array( 1,    'CURRENTMONTH',     'AKTUÁLNÍMĚSÍC'      ),
#    MAG_CURRENTMONTHNAME     => array( 1,    'CURRENTMONTHNAME', 'AKTUÁLNÍMĚSÍCJMÉNO' ),
#	MAG_CURRENTMONTHNAMEGEN  => array( 1,    'CURRENTMONTHNAMEGEN', 'AKTUÁLNÍMĚSÍCGEN' ),
##	MAG_CURRENTMONTHABBREV   => array( 1,    'CURRENTMONTHABBREV' 'AKTUÁLNÍMĚSÍCZKR'  ),
#	MAG_CURRENTDAY           => array( 1,    'CURRENTDAY',       'AKTUÁLNÍDEN' ),
#    MAG_CURRENTDAYNAME       => array( 1,    'CURRENTDAYNAME',   'AKTUÁLNÍDENJMÉNO'   ),
#    MAG_CURRENTYEAR          => array( 1,    'CURRENTYEAR',      'AKTUÁLNÍROK'        ),
#    MAG_CURRENTTIME          => array( 1,    'CURRENTTIME',      'AKTUÁLNÍČAS'        ),
#    MAG_NUMBEROFARTICLES     => array( 1,    'NUMBEROFARTICLES', 'POČETČLÁNKŮ'        ),
#    MAG_PAGENAME             => array( 1,    'PAGENAME',         'NÁZEVSTRANY'        ),
#  	MAG_PAGENAMEE			 => array( 1,    'PAGENAMEE',        'NÁZEVSTRANYE'       ),
#  	MAG_NAMESPACE            => array( 1,    'NAMESPACE',        'JMENNÝPROSTOR'      ),
#  	MAG_MSG                  => array( 0,    'MSG:'                   ),
#  	MAG_SUBST                => array( 0,    'SUBST:',           'VLOŽIT:'            ),
#    MAG_MSGNW                => array( 0,    'MSGNW:',           'VLOŽITNW:'          ),
#  	MAG_END                  => array( 0,    '__END__',          '__KONEC__'          ),
#    MAG_IMG_THUMBNAIL        => array( 1,    'thumbnail', 'thumb', 'náhled'           ),
#    MAG_IMG_RIGHT            => array( 1,    'right',            'vpravo'             ),
#    MAG_IMG_LEFT             => array( 1,    'left',             'vlevo'              ),
#    MAG_IMG_NONE             => array( 1,    'none',             'žádné'              ),
#    MAG_IMG_WIDTH            => array( 1,    '$1px'                   ),
#    MAG_IMG_CENTER           => array( 1,    'center', 'centre', 'střed'              ),
#    MAG_IMG_FRAMED	         => array( 1,    'framed', 'enframed', 'frame', 'rám'     ),
#    MAG_INT                  => array( 0,    'INT:'                   ),
#    MAG_SITENAME             => array( 1,    'SITENAME',         'NÁZEVSERVERU'       ),
#    MAG_NS                   => array( 0,    'NS:'                    ),
#  	MAG_LOCALURL             => array( 0,    'LOCALURL:',        'MÍSTNÍURL:'         ),
#  	MAG_LOCALURLE            => array( 0,    'LOCALURLE:',       'MÍSTNÍURLE:'        ),
#  	MAG_SERVER               => array( 0,    'SERVER'                 ),
##	MAG_REVISIONID           => array( 1,    'REVISIONID',       'IDREVIZE'           )
#);

/* private */ $wgAllMessagesCs = array(

# Části textu používané různými stránkami:
'categories' => 'Kategorie',
'category' => 'kategorie',
'category_header' => 'Články v kategorii „$1“',
'subcategories' => 'Podkategorie',

# Dates
'sunday' => 'neděle',
'monday' => 'pondělí',
'tuesday' => 'úterý',
'wednesday' => 'středa',
'thursday' => 'čtvrtek',
'friday' => 'pátek',
'saturday' => 'sobota',
'january' => 'leden',
'february' => 'únor',
'march' => 'březen',
'april' => 'duben',
'may_long' => 'květen',
'june' => 'červen',
'july' => 'červenec',
'august' => 'srpen',
'september' => 'září',
'october' => 'říjen',
'november' => 'listopad',
'december' => 'prosinec',
'jan' => '1.',
'feb' => '2.',
'mar' => '3.',
'apr' => '4.',
'may' => '5.',
'jun' => '6.',
'jul' => '7.',
'aug' => '8.',
'sep' => '9.',
'oct' => '10.',
'nov' => '11.',
'dec' => '12.',

# Písmena, která se mají objevit jako část odkazu ve formě '[[jazyk]]y' atd:
'linktrail'     => '/^((?:[a-z]|á|č|ď|é|ě|í|ň|ó|ř|š|ť|ú|ů|ý|ž)+)(.*)$/sD',
'mainpage'              => 'Hlavní strana',
'mainpagetext'  => 'Wiki software úspěšně nainstalován.',
'mainpagedocfooter' => 'Podívejte se prosím do [http://meta.wikipedia.org/wiki/MediaWiki_i18n dokumentace k nastavení rozhraní] a [http://meta.wikipedia.org/wiki/MediaWiki_User%27s_Guide uživatelské příručky] pro nápovědu k použití a nastavení.',
'portal'                => 'Portál {{grammar:2sg|{{SITENAME}}}}',
'portal-url'            => '{{ns:4}}:Portál {{grammar:2sg|{{SITENAME}}}}',
'about'                 => 'Úvod',
'aboutsite' => 'O&nbsp;{{grammar:6sg|{{SITENAME}}}}',
'aboutpage'             => '{{SITENAME}}',
'article' => 'Obsahová stránka',
'help'                  => 'Nápověda',
'helppage'              => '{{ns:12}}:Obsah',
'wikititlesuffix' => '{{SITENAME}}',
'bugreports'    => 'Hlášení chyb',
'bugreportspage' => '{{ns:4}}:Chyby',
'sitesupport'   => 'Sponzorství',
'sitesupport-url' => 'Project:Sponzorství',
'faq'                   => 'Často kladené otázky',
'faqpage'               => '{{ns:12}}:Často kladené otázky',
'edithelp'              => 'Pomoc při editování',
'newwindow'             => '(otevře se v novém okně)',
'edithelppage'  => '{{ns:12}}:Jak_editovat_stránku',
'cancel'                => 'Storno',
'qbfind'                => 'Hledání',
'qbbrowse'              => 'Listování',
'qbedit'                => 'Editování',
'qbpageoptions' => 'Tato stránka',
'qbpageinfo'    => 'Kontext',
'qbmyoptions'   => 'Moje volby',
'qbspecialpages'        => 'Speciální stránky',
'moredotdotdot'	=> 'Další…',
'mypage'                => 'Moje stránka',
'mytalk'        => 'Moje diskuse',
'anontalk'              => 'Diskuse k této IP adrese',

# Metadata in edit box
'metadata' => '<b>Metadata</b> (vysvětlení najdete <a href="$1">zde</a>)',
'metadata_page' => '{{ns:4}}:Metadata',

'navigation' => 'Navigace',

# POZNÁMKA: Pro odstranění „aktualit“ z postranního panelu nastavte
# "currentevents" => "-"
'currentevents' => 'Aktuality',
'currentevents-url' => 'Aktuality',

# POZNÁMKA: Pro odstranění „Vyloučení odpovědnosti“ nastavte
# "disclaimers" => "-"
'disclaimers' => 'Vyloučení odpovědnosti',
'disclaimerpage' => '{{ns:4}}:Vyloučení_odpovědnosti',
'errorpagetitle' => 'Chyba',
'returnto'		=> 'Návrat na stránku „$1“.',
'tagline' => '<small>Z {{grammar:2sg|{{SITENAME}}}}</small>',
'whatlinkshere' => 'Odkazuje sem',
'help'                  => 'Nápověda',
'search'                => 'Hledat',
'go'            => 'Jít na', #FIXME
'history'               => 'Historie',
'history_short' => 'Historie',
'info_short'    => 'Informace',
'printableversion' => 'Verze k tisku',
'edit' => 'Editovat',
'editthispage'  => 'Editovat stránku',
'delete' => 'Smazat',
'deletethispage' => 'Smazat stránku',
'undelete_short' => 'Obnovit $1 verzí',
'undelete_short1' => 'Obnovit $1 verzi',
'protect' => 'Zamknout',
'protectthispage' => 'Zamknout stránku',
'unprotect' => 'Odemknout',
'unprotectthispage' => 'Odemknout stránku',
'newpage' => 'Nová stránka',
'talkpage'              => 'Diskusní stránka',
'specialpage' => 'Speciální stránka',
'personaltools' => 'Osobní nástroje',
'postcomment'   => 'Přidat komentář',
'addsection'   => '+',
'articlepage'   => 'Prohlédnout si článek',
'subjectpage'   => 'Stránka námětu', #FIXME: ? (zřejmě se vůbec nepoužívá)
'talk' => 'Diskuse',
'toolbox' => 'Nástroje',
'userpage' => 'Prohlédnout si uživatelovu stránku',
'wikipediapage' => 'Prohlédnout si stránku o projektu',
'imagepage' =>       'Prohlédnout si stránku o obrázku',
'viewtalkpage' => 'Ukázat diskusi',
'otherlanguages' => 'V jiných jazycích',
'redirectedfrom' => '(Přesměrováno z $1)',
'lastmodified'  => ' Stránka byla naposledy editována v $1.',
'viewcount'             => 'Stránka byla zobrazena $1-krát.',
'copyright'     => 'Obsah je dostupný pod $1.',
'poweredby'     => '{{SITENAME}} funguje pomocí [http://www.mediawiki.org/ MediaWiki open source wiki engine].',
'printsubtitle' => '(Z {{SERVER}})',
'protectedpage' => 'Zamčená stránka',
'administrators' => '{{ns:4}}:Správci',
'sysoptitle'    => 'Pouze pro správce',
'sysoptext'      => 'Žádaný úkon může provést jen správce. Podívejte se prosím na $1.',
'developertitle' => 'Jen pro vývojáře',
'developertext'  => 'Žádaný úkon může provést jen vývojář. Podívejte se prosím na $1.',
'bureaucrattitle' => 'Pouze pro byrokraty',
'bureaucrattext'  => 'Žádaný úkon může provést jen byrokrat.',
'nbytes'          => '$1 B',
'ok'              => 'OK',
'sitetitle'       => '{{SITENAME}}',
'pagetitle'       => '$1 – {{SITENAME}}',
'sitesubtitle'  => '{{SITENAME}}: Otevřená Encyklopedie',
'retrievedfrom' => 'Citováno z „$1“', #FIXME: Ukazuje se po tisku strany
'newmessages' => 'Máte $1.',
'newmessageslink' => 'nové zprávy',
'editsection'=>'editovat',
'toc' => 'Obsah',
'showtoc' => 'zobrazit',
'hidetoc' => 'skrýt',
'thisisdeleted' => '$1 – prohlédnout nebo obnovit?',
'restorelink' => 'Počet smazaných editací: $1',		#TODO: plural
'feedlinks' => 'Kanály:',
'sitenotice'    => '-', # the equivalent to wgSiteNotice

# Short words for each namespace, by default used in the 'article' tab in monobook
'nstab-main' => 'Článek',
'nstab-user' => 'Uživatelova stránka',
'nstab-media' => 'Soubor',
'nstab-special' => 'Speciální',
'nstab-wp' => '{{SITENAME}}',
'nstab-image' => 'Soubor',
'nstab-mediawiki' => 'Hlášení',
'nstab-template' => 'Šablona',
'nstab-help' => 'Nápověda',
'nstab-category' => 'Kategorie',

# Main script and global functions
#
'nosuchaction'  => 'Neznámý úkon',
'nosuchactiontext' => 'Tato wiki nezná činnost (action) uvedenou v URL.',
'nosuchspecialpage' => 'Neexistující speciální stránka',
'nospecialpagetext' => 'Žádaná speciální stránka na této wiki neexistuje.',

# General errors
#
'error'         => 'Chyba',
'databaseerror' => 'Databázová chyba',
'dberrortext'   => 'Při dotazu do databáze došlo k syntaktické chybě.
Příčinou může být chyba v programu.
Poslední dotaz byl:
<blockquote><tt>$1</tt></blockquote>
z funkce \'<tt>$2</tt>\'. 
MySQL vrátil chybu \'<tt>$3: $4</tt>\'.',
'dberrortextcl' => 'Při dotazu do databáze došlo k syntaktické chybě.
Poslední dotaz byl:
<blockquote><tt>$1</tt></blockquote>
z funkce \'<tt>$2</tt>\'. 
MySQL vrátil chybu \'<tt>$3: $4</tt>\'.',
'noconnect'             => 'Promiňte! Tato wiki má nějaké technické potíže a nepodařilo se připojit k databázovém serveru.<br />
$1',
'nodb'                  => 'Nebylo možné vybrat databázi $1',
'cachederror'           => 'Následuje kopie požadované stránky z cache, která nemusí být aktuální.',
'laggedslave'			=> 'Upozornění: Stránka nemusí být zcela aktuální.',
'readonly'              => 'Databáze je uzamčena',
'enterlockreason' => 'Udejte důvod zamčení, včetně odhadu, za jak dlouho dojde k odemčení.',
'readonlytext'  => 'Databáze je nyní uzamčena, takže nelze ukládat nové doplňky a změny.
Důvodem je pravděpodobně pravidelná údržba, po které se vše vrátí do normálního stavu.
Správce, který databázi zamkl, zanechal následující zprávu:
<p>$1',
'missingarticle' => 'Databáze nenašla text článku, který měla najít, nazvaného „$1“.
<p>Důvodem je obvykle zastaralý odkaz do historie smazané stránky.
<p>V jiném případě jste možná narazil(a) na chybu v programu. Oznamte to prosím správci systému (zapamatujte si použité URL).',
'internalerror' => 'Vnitřní chyba',
'filecopyerror' => 'Nebylo možné zkopírovat soubor  „$1“ na „$2“.',
'filerenameerror' => 'Nebylo možné přejmenovat soubor „$1“ na „$2“.',
'filedeleteerror' => 'Nebylo možné smazat soubor „$1“.',
'filenotfound'  => 'Nebylo možné najít soubor „$1“.',
'unexpected'    => 'Neočekávaná hodnota: "$1"="$2".',
'formerror'             => 'Chyba: nebylo možné odeslat formulář',   
'badarticleerror' => 'Tento úkon nelze použít na tento článek.',
'cannotdelete'  => 'Nebylo možné smazat zvolenou stránku ani soubor. (Možná už byla smazána někým jiným.)',
'badtitle'              => 'Neplatný název',
'badtitletext'  => 'Požadovaný název stránky byl neplatný, prázdný nebo nesprávně adresovaný na jinojazyčný název nebo jiný článek {{grammar:2sg|{{SITENAME}}}}.',
'perfdisabled' => 'Omlouváme se. Tato služba byla dočasně znepřístupněna, protože zpomalovala databázi natolik, že nikdo nemohl používat wiki.',
'perfdisabledsub' => 'Tady je uložená kopie z $1:', # obsolete?
'perfcached' => ' Následující data jsou z cache a nemusí být plně aktuální:',
'wrong_wfQuery_params' => 'Nesprávné parametry do wfQuery()<br />
Funkce: $1<br />
Dotaz: $2',
'viewsource' => ' Ukázat zdroj',
'protectedtext' => 'Tato stránka byla zamčena, takže ji nelze editovat; je mnoho důvodů, proč se tak mohlo stát. Vizte prosím [[{{ns:4}}:Stránka je zamčena]]. Můžete si prohlédnout a okopírovat zdrojový text této stránky:',
'seriousxhtmlerrors' => 'Tidy nalezl v xhtml kódu závažné chyby.',
'sqlhidden' => '(SQL dotaz skryt)',

# Login and logout pages
#
'logouttitle'   => 'Nashledanou!',
'logouttext'    => 'Nyní jste odhlášeni.<br />
Tento počítač může být používán k prohlížení a editaci {{grammar:2sg|{{SITENAME}}}} bez uživatelského jména, nebo pro přihlášení jiného uživatele. Upozorňujeme, že některé stránky se mohou i nadále zobrazovat, jako byste byli dosud přihlášeni. Tento jev potrvá do smazání cache vašeho prohlížeče.',

'welcomecreation' => '<h2>Vítejte, $1!</h2> Váš účet je vytvořen.
<font color=\'red\'>Nezapomeňte si upravit své nastavení!</font>',

'loginpagetitle' => 'Přihlaste se', #FIXME
'yourname'              => 'Název vašeho účtu', #FIXME buď heslo nebo jméno uživatele nebo název účtu atd.?
'yourpassword'  => 'Vaše heslo',
'yourpasswordagain' => 'Napište heslo znovu',
'newusersonly'  => ' (pouze noví uživatelé)',
'remembermypassword' => 'Pamatovat si heslo mezi jednotlivými přihlášeními.',
'loginproblem'  => '<b>Nastal problém při vašem přihlášení.</b><br />Zkuste to znovu!',
'alreadyloggedin' => "<font color=\'red\'><b>Uživateli $1, již jste přihlášen!</b></font><br />\n",

'login'                 => 'Přihlašte se', #FIXME, what exactly do the following go to?
'loginprompt'   => 'K přihlášení do {{grammar:2sg|{{SITENAME}}}} musíte mít povoleny cookies.',
'userlogin'             => 'Přihlašte se',
'logout'                => 'Odhlásit se',
'userlogout'    => 'Na shledanou',
'notloggedin'   => 'Nejste přihlášen(a)',
'createaccount' => 'Vytvořit nový účet',
'createaccountmail'     => 'pomocí e-mailu',
'badretype'             => 'Vámi napsaná hesla nesouhlasí.',
'userexists'    => 'Uživatel se stejným jménem je už registrován. Zvolte jiné jméno.',
'youremail'             => 'Vaše e-mailová adresa *)',
'yourrealname'          => 'Vaše skutečné jméno **)',
'yourlanguage'	=> 'Jazyk rozhraní',
'yourvariant'  => 'Jazyková varianta',
'yournick'              => 'Alternativní podpis',
'emailforlost'  => 'Pole označená hvězdičkami (*, **) nejsou povinná. Pokud zadáte e-mailovou adresu, budou vás moci ostatní uživatelé kontaktovat, aniž by tato adresa byla zobrazena; také vám na tuto adresu může být zasláno nové heslo v případě, že své heslo zapomenete.<br /><br />Vaše skutečné jméno, pokud ho zadáte, bude použito pro označení autorství vaší práce.',
'prefs-help-email-enotif' => 'Na tuto adresu vám budou zasílány informace o změně stránek, pokud o ně požádáte.',
'prefs-help-realname' 	=> '**) Skutečné jméno (volitelné): pokud ho zadáte, bude použito pro označení autorství vaší práce.<br />',
'prefs-help-email'      => '*) E-mail (volitelný): Umožní ostatním uživatelům vás kontaktovat, aniž by tato adresa byla zobrazena; také vám na tuto adresu může být zasláno nové heslo v případě, že své heslo zapomenete.',
'prefs-help-userdata' 	=> '
*) E-mail (volitelný): Umožní ostatním uživatelům vás kontaktovat, aniž by tato adresa byla zobrazena; také vám na tuto 
adresu může být zasláno nové heslo v případě, že své heslo zapomenete.<br />
**) Skutečné jméno (volitelné): pokud ho zadáte, bude použito pro označení autorství vaší práce.<br />',
'loginerror'    => 'Chyba při přihlašování',
'nocookiesnew'  => 'Uživatelský účet byl vytvřen, ale nejste přihlášeni. {{SITENAME}} používá cookies k přihlášení uživatelů. Vy máte cookies vypnuty. Prosím zapněte je a přihlaste se znovu s vaším novým uživatelským jménem a heslem.',
'nocookieslogin'      => '{{SITENAME}} používá cookies k přihlášení uživatelů. Vy máte cookies vypnuty. Prosím zapněte je a zkuste znovu.',
'noname'                => 'Musíte uvést jméno svého účtu.',
'loginsuccesstitle' => 'Přihlášení uspělo',
'loginsuccess'	=> 'Nyní jste přihlášen na {{grammar:6sg|{{SITENAME}}}} jako uživatel „$1“.',
'nosuchuser'	=> 'Neexistuje uživatel se jménem „$1“. Zkontrolujte zápis, nebo vytvořte účet pomocí níže uvedeného formuláře.',
'nosuchusershort'	=> 'Neexistuje uživatel se jménem „$1“. Zkontrolujte zápis.',
'wrongpassword' => 'Vámi uvedené heslo nesouhlasí. Zkuste to znovu.',
'mailmypassword' => 'Poslat e-mailem dočasné heslo',
'mailmypasswordauthent'	=> 'Poslat e-mailem dočasné heslo',
'passwordremindertitle' => 'Ověření e-mailu a dočasné heslo pro přihlášení do {{grammar:2sg|{{SITENAME}}}}',
'passwordremindertext' => 'Někdo (patrně vy, z IP adresy $1) žádal, abychom vám poslali dočasné jednorázové heslo pro přihlášení do {{grammar:2sg|{{SITENAME}}}}.

Tento e-mail slouží také jako autentizace vaší e-mailové adresy.
Heslo pro uživatele  "$2" je nyní "$3".

Tímto dočasným heslem se můžete přihlásit pouze jednou. Pokud si pamatujete
původní heslo, můžete ho používat dál, jinak si můžete své heslo změnit.

{{SERVER}}{{localurl:Special:Userlogin|wpName=$3&wpPassword=$4&returnto=Special:Preferences}}',
'noemail'		=> 'Uživatel „$1“ nemá zaregistrovanou e-mailovou adresu.',
'passwordsent'	=> 'Dočasné heslo bylo zasláno na e-mailovou adresu registrovanou pro „$1“. Přihlašte se, prosím, znovu, jakmile ho obdržíte.',
'passwordsentforemailauthentication'	=> 'Dočasné heslo bylo zasláno na e-mailovou adresu nově registrovanou pro „$1“. Pro účely ověření se, prosím, přihlašte znovu, jakmile ho obdržíte.',

'loginend'		=> 'Pro registraci si zvolte [[Project:Uživatelské jméno|uživatelské jméno]] a heslo a klikněte na „Vytvořit nový účet“. Nevybírejte si uživatelské jméno, které je jménem politika, vojenského velitele, náboženského činitele nebo události. Nepoužívejte uživatelské jméno, které je urážlivé, pobuřující nebo matoucí. Zvolte si prosím čitelné jméno, ne pouhé číslo.

Pokud potřebujete více informací o přihlašování, podívejte se na článek [[Nápověda:Jak se přihlásit]].

Uživatelé, kteří se vracejí, musejí jen vyplnit své uživatelské jméno a heslo.

K přihlášení do {{grammar:2sg|{{SITENAME}}}} musíte mít zapnuty [[w:cs:HTTP cookie|cookies]].

*Vložení e-mailové adresy je nepovinné a žádné potvrzení e-mailem není vyžadováno. Umožňuje však lidem, aby vás kontaktovali prostřednictvím webu, aniž byste museli svou e-mailovou adresu zveřejnit. Také je pro vás užitečné v případě, že zapomenete heslo.',
'mailerror' => 'Chyba při zasílání e-mailu: $1',
'acct_creation_throttle_hit' => 'Omlouváme se, ale už jste vyrobil(a) $1 účtů. Žádný další už nemůžete vytvořit.',
'emailauthenticated' 	=> 'Vaše e-mailová adresa byla ověřena na $1.',
'emailnotauthenticated'	=> 'Vaše e-mailová adresa <strong>dosud nebyla ověřena</strong> a pokročilé e-mailové funkce do té doby nejsou dostupné.<br />
Pro ověření se přihlašte dočasným heslem, které vám bylo posláno e-mailem, nebo požádejte o nové heslo na přihlašovací stránce.',
'invalidemailaddress'	=> 'Zadaná e-mailová adresa nemůže být přijata, neboť nemá správný formát. Zadejte laskavě platnou e-mailovou adresu, nebo obsah tohoto pole vymažte.',
'disableduntilauthent'	=> '<strong>(neověřeno)</strong>',
'disablednoemail'	=> '<strong>(nedostupné; bez e-mailové adresy)</strong>',

# Edit page toolbar
'bold_sample'=>'Tučný text',
'bold_tip'=>' Tučný text',
'italic_sample'=>'Kurzíva',
'italic_tip'=>'Kurzíva',
'link_sample'=>'Název odkazu',
'link_tip'=>'Vnitřní odkaz',
'extlink_sample'=>'http://www.example.com Titulek odkazu',
'extlink_tip'=>'Externí odkaz (nezapomeňte na předponu http://)',
'headline_sample'=>'Text nadpisu',
'headline_tip'=>'Nadpis druhé úrovně',
'math_sample'=>'Vložit sem vzorec',
'math_tip'=>'Matematický vzorec (LaTeX)',
'nowiki_sample'=>' Vložit sem neformátovaný text',
'nowiki_tip'=>'Ignorovat formátování wiki',
'image_sample'=>'Příklad.jpg',
'image_tip'=>'Vložený obrázek',
'media_sample'=>'Příklad.mp3',
'media_tip'=>'Odkaz na mediální soubor',
'sig_tip'=>'Váš podpis s časovým údajem',
'hr_tip'=>'Vodorovná čára (používejte střídmě)',
'infobox'=>'Stiskněte tlačítko pro zobrazení příkladu',
# alert box shown in browsers where text selection does not work, test e.g. with mozilla or konqueror
'infobox_alert'=>'Prosím vložte text, který chcete naformátovat.\n Ukáže se v informačním rámečku, aby ho šlo zkopírovat.\nPříklad:\n$1\nse stane:\n$2',

# Edit pages
#
'summary'               => '<a href="{{LOCALURLE:Project:Shrnutí_editace}}" class="internal" title="Stručně popište změny, které jste zde učinili">Shrnutí editace</a>',
'subject'               => 'Předmět/nadpis',
'minoredit'		=> 'Tato změna je malá editace.&nbsp;',
'watchthis'             => 'Sledovat tento článek',
'savearticle'   => 'Uložit změny',
'preview'               => 'Náhled',
'showpreview'   => 'Ukázat náhled',
'showdiff'		=> 'Ukázat změny',
'blockedtitle'  => 'Uživatel zablokován',
'blockedtext'   => "Pokoušíte se editovat stránku, ať už kliknutím na tlačítko ''Editovat stránku'', nebo na červený odkaz.

Vaše uživatelské jméno nebo IP adresa však byla [[{{ns:4}}:Blokování|zablokována]]
správcem s uživatelským jménem „$1“. Byl uveden následující důvod:&nbsp;'''$2'''.

Můžete [[Special:Emailuser/$4|poslat e-mail uživateli $4]] nebo jinému
[[Special:Listadmins|správci]] k prodiskutování zablokování. Uvědomte si, že nemůžete použít
nabídku „Poslat e-mail“, jestliže nemáte na {{grammar:6sg|{{SITENAME}}}} účet a uvedenu platnou e-mailovou adresu
ve svém [[Special:Preferences|nastavení]].

Vaše IP adresa je '''$3'''. Prosím vložte tuto adresu do všech žádostí, které pošlete.

Pokud chcete vědět, kdy zablokování vyprší, podívejte se prosím na [[Special:Ipblocklist|seznam blokovaných adres IP]].

Pokud se potřebujete podívat na wiki text článku, můžete použít nabídku [[Special:Export|exportovat stránky]].

== Bez viny? ==
Někdy jsou zablokovány celé skupiny IP adres nebo adresy veřejných [[w:cs:proxy server|proxy serverů]].
To znamená, že mnoho nevinných lidí nemůže editovat. Pokud nastal tento případ, měl
by být vysvětlen v důvodech zablokování.

Někdy jsou také zablokovány dynamické IP adresy, obvykle na 24 hodin. Výjimečně
se pak může stát, že jsou zablokováni uživatelé se stejnou dynamickou IP adresou
díky tomu, že jejich nynější IP adresa byla používána zablokovaným uživatelem.

Omlouváme se za nepohodlí s tím spojené. Pokud se tento problém objeví opakovaně
a chcete nám pomoci ho vyřešit, kontaktujte [[Project:Správci|správce wiki]]
a vašeho [[w:cs:Poskytovatel Internetu|poskytovatele Internetu]] (ISP). Správce by měl
být schopen zjistit čas, datum a IP adresu používanou pro nevhodné dotyčné jednání.
Tuto informaci potom můžete předložit ISP a vysvětlit, že nemůžete editovat {{grammar:4sg|{{SITENAME}}}}
kvůli nevhodnému chování jiného uživatele tohoto ISP a požádat o vyřešení problému.

== Jen číst? ==
Blokování nebrání čtení stránek, jen jejich editaci. Pokud jste si chtěli jen
přečíst stránku a vidíte tuto zprávu, pravděpodobně jste klikli na červený odkaz.
To je odkaz na stránku, která zatím neexistuje, takže se uživateli otevře editační
okénko. Tento problém mít nebudete, pokud budete klikat jen na modré odkazy.",
'whitelistedittitle' => 'Pro editaci je vyžadováno přihlášení',
'whitelistedittext' => 'Pro editaci se musíte [[Special:Userlogin|přihlásit]].',
'whitelistreadtitle' => 'Vyžadováno přihlášení',
'whitelistreadtext' => 'Pro čtení článků se musíte [[Special:Userlogin|přihlásit]].',
'whitelistacctitle' => 'Není vám dovoleno vytvářet uživatelské účty',
'whitelistacctext' => 'Abyste na této wiki mohl(a) vytvářet uživatelské účty, musíte se [[Special:Userlogin|přihlásit]] a mít příslušná oprávnění.',
'loginreqtitle' => 'Vyžadováno přihlášení',
'loginreqtext'  => ' K prohlížení jiných stránek se musíte [[Special:Userlogin|přihlásit]].',
'accmailtitle' => 'Heslo odesláno.',
'accmailtext' => 'Heslo pro „$1“ bylo odesláno na $2.',
'newarticle'    => '(Nový)',
'newarticletext' => "<div style=\"border: 1px solid #cccccc; padding: 7px;\">'''Na {{grammar:6sg|{{SITENAME}}}} dosud neexistuje stránka se jménem {{PAGENAME}}.'''
* Pokud chcete takový článek vytvořit, napište jeho text do rámečku níže a stiskněte tlačítko ''Uložit změny''. Váš text bude okamžitě zveřejněn.
* Nevytvářejte prosím reklamní články.
* Pokud jste na {{grammar:6sg|{{SITENAME}}}} nováčkem, přečtěte si prosím napřed [[Nápověda:Obsah|nápovědu]]. Pro experimenty prosím používejte k tomu určené [[Project:Pískoviště|pískoviště]].</div>",
'talkpagetext' => '<!-- MediaWiki:talkpagetext -->',
'anontalkpagetext' => "---- ''Toto je diskusní stránka anonymního uživatele, který si dosud nevytvořil účet nebo ho nepoužívá. Musíme proto použít číselnou [[w:cs:IP adresa|IP adresu]] k jeho identifikaci. Taková IP adresa může být sdílena několika uživateli. Pokud jste anonymní uživatel a cítíte, že jsou Vám adresovány irrelevantní komentáře, prosím [[Special:Userlogin|vytvořte si účet nebo se přihlaste]] a tím se vyhnete budoucí záměně s jinými anonymními uživateli.''",
'noarticletext' => '(Článek zatím neobsahuje text)',
'clearyourcache' => "'''Poznámka:''' Po uložení musíte smazat cache vašeho prohlížeče, jinak změny neuvidíte: '''Mozilla:''' klikněte na ''reload'' (nebo ''ctrl-r''), '''IE / Opera:''' ''ctrl-f5'', '''Safari:''' ''cmd-r'', '''Konqueror''' ''ctrl-r''.",
'usercssjsyoucanpreview' => '<strong>Tip:</strong> Použijte tlačítko „Ukázat náhled“ k testování vašeho nového css/js před uložením.',
'usercsspreview' => "'''Pamatujte, že si prohlížíte jen náhled vašeho uživatelského css, neboť ještě nebylo uloženo!'''",
'userjspreview' => "'''Pamatujte, že testujete a prohlížíte pouze náhled vašeho uživatelského javascriptu, dosud nebyl uložen!'''",
'updated'               => '(Změna uložena)', #FIXME: ?
'note'			=> '<strong>Poznámka:</strong>&nbsp;', #FIXME: Where does this come from?
'previewnote'   => 'Pamatujte, že toto je pouze náhled, ne uložení!',
'previewconflict' => 'Tento náhled ukazuje text tak, jak bude vypadat po uložení stránky.', #FIXME
'editing'               => 'Editace stránky $1',
'editingsection'		=> 'Editace stránky $1 (část)',
'editingcomment'		=> 'Editace stránky $1 (komentář)',
'editconflict'  => 'Editační konflikt: $1',
'explainconflict' => 'Někdo změnil stránku po započetí vaší editace. Výše vidíte aktuální text článku. Vaše změny jsou uvedeny dole. Musíte sloučit své změny se stávajícím článkem. <b>Pouze</b> výše uvedený text zůstane uchován po kliknutí na „Uložit“. <p>',
'yourtext'              => 'Váš text',
'storedversion' => ' Uložená verze',
'nonunicodebrowser' => '<strong>UPOZORNĚNÍ: Váš prohlížeč není schopen pracovat se znaky [[w:cs:Unicode|Unicode]], pro editaci stránek prosím použijte nějaký jiný.</strong>',
'editingold'    => '<strong>VAROVÁNÍ: Nyní editujete zastaralou verzi této stránky. Když ji uložíte, všechny změny provedené mezitím se ztratí.</strong>',
'yourdiff'              => 'Rozdíly',
'copyrightwarning' => '<strong>Vaše změny budou okamžitě zveřejněny.</strong> Pokud si chcete pouze editaci vyzkoušet, použijte prosím [[Project:Pískoviště|pískoviště]].<br />
Všechny příspěvky do {{grammar:2sg|{{SITENAME}}}} jsou zveřejňovány podle volné licence GNU pro dokumenty (podívejte se na $1 na detaily). <strong>Pokud si nepřejete, aby váš text byl nemilosrdně upravován a volně šířen, pak ho do {{grammar:2sg|{{SITENAME}}}} neukládejte.</strong> Uložením příspěvku se zavazujete, že je vaším dílem nebo je zkopírován ze zdrojů, které [[w:cs:volné dílo|nejsou chráněny]] autorským právem (tzv. <em>public domain</em>) – to se <strong>netýká</strong> většiny webových stránek. <strong>Nepoužívejte díla chráněná autorským právem bez dovolení!</strong>',
'copyrightwarning2' => '<strong>Vaše změny budou okamžitě zveřejněny.</strong> Pokud si chcete pouze editaci vyzkoušet, použijte prosím [[Project:Pískoviště|pískoviště]].<br />
<strong>Pokud si nepřejete, aby váš text byl nemilosrdně upravován a volně šířen, pak ho do {{grammar:2sg|{{SITENAME}}}} neukládejte.</strong> Uložením příspěvku se zavazujete, že je vaším dílem nebo je zkopírován ze zdrojů, které [[w:cs:volné dílo|nejsou chráněny]] autorským právem (tzv. <em>public domain</em>) – to se <strong>netýká</strong> většiny webových stránek. <strong>Nepoužívejte díla chráněná autorským právem bez dovolení!</strong>',
'longpagewarning' => 'VAROVÁNÍ: Tato stránka je $1 KB dlouhá; některé prohlížeče mohou mít problémy s editováním stran, které se blíží nebo jsou delší než 32 KB. Prosím zvažte rozdělení stránky na více částí.',
'readonlywarning' => 'VAROVÁNÍ: Databáze byla uzamčena kvůli údržbě, takže nebudete moci uložit své změny. Můžete si okopírovat text do souboru a uložit ho na později.',
'protectedpagewarning' => '<strong>Varování:</strong> Tato stránka byla zamčena, takže ji mohou editovat pouze správci. Ujistěte se, že dodržujete <a href="{{LOCALURLE:Project:Pravidla pro zamčené stránky}}">pravidla pro zamčené stránky</a>.',
'templatesused'	=> 'Šablony používané na této stránce:',

# History pages
#
'revhistory'    => 'Historie editací',
'nohistory'             => 'O této stránce neexistuje historie editací.',
'revnotfound'   => 'Verze nenalezena',
'revnotfoundtext' => 'Nelze najít starou verzi, kterou žádáte. Zkuste prosím zkontrolovat URL hledané stránky.\b',
'loadhist'              => 'Načítá se stránka historie editací', #FIXME Apparently not used
'currentrev'    => 'Aktuální verze',
'revisionasof'          => 'Verze z $1',
'revisionasofwithlink'  => 'Verze z $1; $2<br />$3 | $4',
'previousrevision' => '&larr; Starší verze',
'nextrevision'		=> 'Novější verze &rarr;',
'currentrevisionlink'   => 'zobrazit aktuální verzi',
'cur'                   => 'teď',
'next'                  => 'násl',
'last'                  => 'předchozí',
'orig'                  => 'původní',
'histlegend'    => '(teď) = rozdíly oproti nynější verzi, (předchozí) = rozdíly oproti předchozí verzi, <b>m</b> = malá editace',
'history_copyright'    => '-',
'deletedrev'			=> '[smazáno]',

# Diffs
#
'difference'    => '(Rozdíly mezi verzemi)',
'loadingrev'    => 'načítají se verze pro zjištění rozdílů', #FIXME Apparently not used
'lineno'                => 'Řádka $1:',
'editcurrent'   => ' Editovat nynější verzi této stránky',
'selectnewerversionfordiff' => 'Vyberte novější verzi pro porovnání',
'selectolderversionfordiff' => 'Vyberte starší verzi pro porovnání',
'compareselectedversions' => 'Porovnat vybrané verze',

# Search results
#
'searchresults' => 'Výsledky hledání',
'searchresulttext' => 'Pro více informací o tom, jak hledat na {{grammar:6sg|{{SITENAME}}}}, se podívejte na [[Nápověda:Hledání]].',
'searchquery'	=> 'Hledáno „$1“',
'badquery'              => 'Špatně vytvořený vyhledávací dotaz',
'badquerytext'  => 'Nemůžeme zpracovat vaše zadání. Je to pravděpodobně tím, že hledáte slovo kratší než tři písmena, což zatím není podporováno. Může to být také tím, že zadání bylo napsáno nesprávně. Prosím zkuste jiné zadání.',
'matchtotals'	=> 'Zadanému „$1“ odpovídá $2 názvů stran a text $3 stran.',
'nogomatch' => '      Neexistuje žádná stránka, která by měla přesně tento název, zkouším plnotextové vyhledávání.',
'titlematches'  => 'Stránky s odpovídajícím názvem',
'notitlematches' => 'Žádné stránky názvem neodpovídají.',
'textmatches'   => 'Stránky s odpovídajícím textem',
'notextmatches' => 'Žádné stránky textem neodpovídají.',
'prevn'                 => '$1 předchozích',
'nextn'                 => '$1 následujících',
'viewprevnext'  => 'Ukázat ($1) ($2) ($3).',
'showingresults' => 'Zobrazuji <strong>$1</strong> výsledků počínaje od <strong>$2</strong>.',
'showingresultsnum' => 'Zobrazuji <strong>$3</strong> výsledků počínaje od <strong>$2</strong>.',
'nonefound'             => '<strong>Poznámka</strong>: neúspěšná hledání jsou často důsledkem zadání slov, která nejsou indexována, nebo uvedením mnoha slov najednou (ve výsledku se objeví jen ty stránky, které obsahují všechna zadaná slova).',
'powersearch' => 'Hledání',
'powersearchtext' => 'Hledat',
'powersearchtext' => '
Hledat ve jmenných prostorech:<br />
$1<br />
$2 Vypsat přesměrování &nbsp; Hledat $3 $9',
'searchdisabled' => '<p>Omlouváme se. Plnotextové vyhledávání je dočasně nedostupné, aby se zvýšila rychlost načítání běžných článků. Zatím můžete zkusit vyhledávání Googlem; je ale možné, že jeho výsledky nemusí být aktuální.</p>',
'blanknamespace' => ' (Hlavní)',

# Preferences page
#
'preferences'   => 'Nastavení',
'prefsnologin' => 'Nejste přihlášen(a)!',
'prefsnologintext'      => 'Pro nastavení se musíte <a href="{{localurle:Special:Userlogin}}">přihlásit</a>.',
'prefslogintext' => 'Jste přihlášen jako „$1“. Vaše interní identifikační číslo je $2.

Podívejte se na [[{{ns:12}}:Uživatelské nastavení]] pro popis možností.',
'prefsreset'    => 'Nastavení vráceno.', #FIXME: Hmm...
'qbsettings'    => 'Nastavení lišty nástrojů', 
'qbsettingsnote'	=> 'Toto nastavení funguje pouze ve stylech „Standard“ a „Kolínská modř“.',
'changepassword' => 'Změna hesla',
'skin'                  => 'Styl',

'math'                  => 'Matematika',
'dateformat'    => 'Formát data',
'math_failure'          => 'Nelze pochopit',
'math_unknown_error'    => 'neznámá chyba',
'math_unknown_function' => 'neznámá funkce ',
'math_lexing_error'     => 'chyba při lexingu',   #FIXME
'math_syntax_error'     => 'syntaktická chyba',
'math_image_error'      => 'Selhala konverze do PNG; zkontrolujte správnou instalaci latexu, dvips, gs a convertu',
'math_bad_tmpdir'       => 'Nelze zapsat nebo vytvořit dočasný adresář pro matematiku',
'math_bad_output'       => 'Nelze zapsat nebo vytvořit adresář pro výstup matematiky',
'math_notexvc'  => 'Chybí spustitelný texvc; podívejte se prosím do math/README na konfiguraci.',
'prefs-personal' => 'Údaje o uživateli',
'prefs-rc' => ' Poslední změny a pahýly',
'prefs-misc' => ' Různé',
'saveprefs'             => 'Uložit nastavení',
'resetprefs'    => 'Vrátit původní nastavení',
'oldpassword'   => 'Staré heslo',
'newpassword'   => 'Nové heslo',
'retypenew'             => 'Napište znovu nové heslo',
'textboxsize'   => 'Velikost editačního okna',
'rows'                  => 'Řádky',
'columns'               => 'Sloupce',
'searchresultshead' => 'Vyhledávání',
'resultsperpage' => 'Počet nalezených článků na jednu stránku výsledků',
'contextlines'  => ' Počet řádek zobrazených z každé nalezené stránky',
'contextchars'  => ' Počet znaků kontextu na každé řádce',
'stubthreshold' => 'Hranice pro zobrazení pahýlu',
'recentchangescount' => 'Počet zobrazených záznamů v posledních změnách',
'savedprefs'    => 'Vaše nastavení bylo uloženo.',
'timezonelegend' => 'Časové pásmo',
'timezonetext'	=> 'Označte, o kolik se vaše časové pásmo liší od serveru (UTC). Například pro středoevropské časové pásmo (SEČ) vyplňte „01:00“ v zimě, „02:00“ v období platnosti letního času.',
'localtime'     => 'Místní časové pásmo',
'timezoneoffset' => 'Posun',
'servertime'	=> 'Aktuální čas na serveru',
'guesstimezone' => 'Načíst z prohlížeče',
'emailflag'     => 'Zakázat e-maily od jiných uživatelů',
'defaultns'     => 'Implicitně hledat v těchto jmenných prostorech:',
'default'		=> 'implicitní',
'files'			=> 'Soubory',

# User levels special page
#

# switching pan
'grouplevels-lookup-group' => 'Spravovat práva skupin',
'grouplevels-group-edit' => 'Existující skupiny: ',
'editgroup' => 'Upravit skupinu',
'addgroup' => 'Přidat skupinu',

'userlevels-lookup-user' => 'Spravovat uživatelské skupiny',
'userlevels-user-editname' => 'Zadejte uživatelské jméno: ',
'editusergroup' => 'Upravit uživatelskou skupinu',

# group editing
'grouplevels-editgroup' => 'Upravit skupinu',
'grouplevels-addgroup' => 'Přidat skupinu',
'grouplevels-editgroup-name' => 'Název skupiny: ',
'grouplevels-editgroup-description' => 'Popis skupiny (max. 255 znaků):<br />',
'savegroup' => 'Uložit skupinu',

# user groups editing
'userlevels-editusergroup' => 'Upravit uživatelské skupiny',
'saveusergroups' => 'Uložit uživatelské skupiny',
'userlevels-groupsmember' => 'Člen skupin:',
'userlevels-groupsavailable' => 'Dostupné skupiny:',
'userlevels-groupshelp' => 'Zvolte skupiny, do/ze kterých chcete uživatele přidat/odebrat.
Nezvolené skupiny nebudou změněny. Skupinu můžete vyřadit z vybraných pomocí CTRL + Levé tlačítko myši',

# Recent changes
#
'changes' => 'změny',
'recentchanges' => 'Poslední změny',
'recentchanges-url' => 'Speciální:Recentchanges',
'recentchangestext' => 'Sledujte poslední změny na {{grammar:6sg|{{SITENAME}}}} na této stránce.',
'rcloaderr'             => 'Načítám seznam posledních změn',
'rcnote'                => 'Níže je posledních <strong>$1</strong> změn za posledních <strong>$2</strong> dnů.',
'rcnotefrom'    => 'Níže je nejvýše <b>$1</b> změn od <b>$2</b>.',
'rclistfrom'    => 'Ukázat nové změny, počínaje od $1',
'showhideminor' => '$1 menší editace | $2 roboty | $3 přihlášené uživatele',
'rclinks'               => 'Ukázat $1 posledních změn během posledních $2 dnů; $3.',
'rchide'                => 'jako $4; $1 menších editací; $2 vedlejších jmenných prostorů; $3 násobných editací.',
'rcliu'                 => '; $1 editací od přihlášených uživatelů',
'diff'                  => 'rozdíl',
'hist'                  => 'historie',
'hide'                  => 'skrýt',
'show'                  => 'ukázat',
'tableform'             => 'tabulka',
'listform'              => 'seznam',
'nchanges'              => '$1 změn',
'minoreditletter' => 'm',
'newpageletter' => 'N',
'sectionlink' => '&rarr;',
'number_of_watching_users_RCview' 	=> '[$1]',
'number_of_watching_users_pageview' 	=> '[Sledujících uživatelů: $1]',	#TODO: plural

# Upload
#
'upload'                => 'Načíst soubor',
'uploadbtn'             => 'Načíst soubor',
'uploadlink'    => 'Načíst obrázek',
'reupload'              => 'Načíst znovu',
'reuploaddesc'  => 'Vrátit se k načtení.',
'uploadnologin' => 'Nejste přihlášen(a)',
'uploadnologintext'     => 'Pro načtení souboru se musíte <a href="{{localurle:Special:Userlogin}}">přihlásit</a>.',
'uploadfile'    => 'Načíst soubor',
'uploaderror'   => 'Při načítání došlo k chybě',
'uploadtext'	=> "
'''POZOR!''' Před nahráváním souborů si zcela určitě přečtěte
[[Project:Pravidla použití obrázků|pravidla použití obrázků]]
a dodržujte je.

Pro prohlížení a hledání již dříve nahraných souborů se podívejte
na [[Special:Imagelist|seznam načtených souborů]], popř.
[[Special:Newimages|galerii nových obrázků]]. Všechny načtení
a smazání jsou zaznamenány v [[Special:Log|protokolovacích záznamech]].

Pomocí níže uvedeného formuláře můžete na wiki nahrát obrázky a jiné
soubory, které poté budete moci použít v článcích. Ve většině prohlížečů
je zobrazeno tlačítko „Procházet…“, pomocí kterého budete moci
vybrat soubor k načtení, jehož jméno se poté objeví v políčku
vedle tlačítka. Také musíte potvrdit, že nahráním souboru neporušujete
ničí autorská práva. Poté stiskněte tlačítko „Načíst soubor“ k
dokončení načtení. Buďte trpěliví, nahrávání může chvíli trvat.

Preferované formáty jsou JPEG pro fotografie, PNG pro schémata
a OGG pro zvuky. Používejte laskavě smysluplná jména souborů,
soubor po načtení nelze přejmenovat.

Pro vložení obrázku do stránky použijte syntaxi
<code><nowiki>[[{{ns:6}}:soubor.jpg]]</nowiki></code> nebo
<code><nowiki>[[{{ns:6}}:soubor.png|popisek]]</nowiki></code>, popř.
<code><nowiki>[[{{ns:-2}}:soubor.ogg]]</nowiki></code> pro zvuky.

Uvědomte si laskavě, že stejně jako u ostatních wikistránek mohou
ostatní uživatelé vámi nahraný soubor smazat či upravit, pokud to
uznají za vhodné; pokud budete tuto funkci zneužívat, může být
váš uživatelský účet zablokován.",
'uploadlog'		=> 'kniha nahrávek',
'uploadlogpage' => 'Kniha_nahrávek',
'uploadlogpagetext' => 'Níže najdete seznam nejnovějších souborů.',
'filename'              => 'Soubor',
'filedesc'              => 'Popis',
'filestatus' => 'Autorská práva',
'filesource' => 'Zdroj',
'affirmation'   => 'Potvrzuji, že majitel autorských práv k tomuto souboru souhlasí s poskytnutím licence podle $1.',
'copyrightpage' => '{{ns:4}}:Autorské právo',
'copyrightpagename' => 'podmínek {{grammar:2sg|{{SITENAME}}}}',
'uploadedfiles' => 'Načtené soubory',
'noaffirmation' => 'Musíte potvrdit, že uložení tohoto souboru neporušuje autorské právo.',
'ignorewarning' => 'Ignorovat varování a uložit soubor.',
'minlength'             => 'Jméno souboru se musí skládat nejméně ze tří písmen.',
'illegalfilename'       => 'Název souboru "$1" obsahuje znaky, které nejsou povoleny v názvech stránek. Prosím přejmenujte soubor a zkuste jej nahrát znovu.',
'badfilename'	=> 'Jméno souboru bylo změněno na „$1“.',
'badfiletype'	=> '„.$1“ není jeden z doporučených typů souborů.',
'largefile'             => 'Doporučuje se, aby délka souboru nepřesahovala $1&nbsp;B, tento soubor má $2&nbsp;B.',
'emptyfile'             => 'Soubor, který jste vložili, se zdá být prázdný. Mohl to způsobit překlep v názvu souboru. Prosím zkontrolujte, zda jste opravdu chtěli vložit tento soubor.',
'fileexists'    => ' Soubor s tímto jménem již existuje, prosím podívejte se na $1, pokud nevíte jistě, zda chcete tento soubor nahradit.',
'successfulupload' => 'Načtení úspěšně provedeno!',
'fileuploaded'	=> 'Soubor „$1“ byl úspěšně načten. Prosím klikněte na tento odkaz: ($2), který vede na stránku popisu a napište tam informace o souboru: odkud pochází, kdy byl vytvořen a kým; a cokoliv dalšího, co o něm můžete vědět. Pokud je to obrázek, můžete ho do stránek vložit takto: <tt><nowiki>[[</nowiki>{{ns:6}}:$1|thumb|Nadpis]]</tt>',
'uploadwarning' => 'Varování',
'savefile'              => 'Uložit soubor',
'uploadedimage' => 'načítá „[[$1]]“',
'uploaddisabled' => 'Promiňte, ale načítání souborů je vypnuto.',
'uploadcorrupt' => 'Soubor je poškozen nebo nemá správnou příponu. Zkontrolujte prosím soubor a zkuste ho načíst znovu.',

# Image list
#
'imagelist'             => 'Seznam načtených obrázků',
'imagelisttext' => 'Níže je seznam $1 obrázků, setříděných $2.',
'getimagelist'  => 'načítám seznam obrázků',
'ilshowmatch'   => 'Ukázat soubory, jejichž jména vyhovují',
'ilsubmit'              => 'Hledat',
'showlast'              => 'Ukázat posledních $1 obrázků tříděných $2.',
'byname'                => 'podle jména',
'bydate'                => 'podle data',
'bysize'                => 'podle velikosti',
'imgdelete'             => 'smazat',
'imgdesc'               => 'popis',
'imglegend'             => '(popis) = ukázat / editovat popis souboru.',
'imghistory'    => 'Historie načtených souborů',
'revertimg'             => 'vrátit',
'deleteimg'             => 'smazat',
'deleteimgcompletely'           => 'smazat úplně',
'imghistlegend' => '(teď) = toto je současná verze souboru, (smazat úplně) = smazat všechny verze tohoto souboru, (smazat) = smazat jen tuto verzi, (vrátit) = obnovit starou verzi. <br /> <i>Klikněte na datum pro zobrazení obrázku, který byl uložen v ten den.</i>',
'imagelinks'    => 'Odkazy k souboru',
'linkstoimage'  => 'Na soubor odkazují tyto stránky:',
'nolinkstoimage' => 'Na tento soubor neodkazuje žádná stránka.',
'sharedupload' => 'Tento soubor je sdílený a může být používán ostatními projekty.',
'shareduploadwiki' => 'Více informací najdete na [$1 stránce s popisem].',

# User list
'userlist'		=> 'Seznam uživatelů',
'userlisttext'	=> 'Níže je seznam $1 uživatelů, setříděných $2.',
'ulshowmatch'	=> 'Ukázat uživatele, jejichž jména vyhovují',
'ulsubmit'		=> 'Hledat',
'ulshowlast'	=> 'Ukázat posledních $1 uživatelů tříděných $2.',
'byrights'		=> 'podle oprávnění',

# Statistics
#
'statistics'    => 'Statistika',
'sitestats'             => 'O serveru',
'userstats'             => 'O uživatelích',
'sitestatstext' => 'V databázi je celkem <strong>$1</strong> stránek. Toto číslo zahrnuje diskusní stránky, stránky o {{grammar:6sg|{{SITENAME}}}}, pahýly, přesměrování a další, které nejsou články v pravém slova smyslu. Kromě nich zbývá <strong>$2</strong> pravděpodobně skutečných článků.<p>Od založení wiki bylo navštíveno celkem <strong>$3</strong> stránek a editováno <strong>$4</strong>-krát. To činí v průměru <strong>$5</strong> editací na stránku a <strong>$6</strong> návštěv na editaci.',
'userstatstext' => 'Je zde <strong>$1</strong> registrovaných uživatelů. <strong>$2</strong> z nich jsou správci (podívejte se na $3).',

# Maintenance Page
#
'maintenance'           => 'Nástroje pro opravy a údržbu',
'maintnancepagetext'    => 'Zde jsou různé nástroje pro opravy a všeobecnou údržbu dat. Některé funkce mohou zatěžovat databázi, nenačítejte proto po každé drobné opravě!',
'maintenancebacklink'   => 'Zpět na stránku nástrojů',
'disambiguations'       => ' Stránky s rozcestníky',
'disambiguationspage'   => '{{ns:12}}:Rozcestníky',
'disambiguationstext'   => 'Následující stránky odkazují na <i>stránku s rozcestníky</i>. Místo toho by měly by odkazovat na náležitou stránku.<br />Se stránkou je zacházeno jako s rozcestníkem, pokud se na ni odkazuje z $1.<br />Odkazy z jiných jmenných prostorů zde <i>nejsou</i> vypsány.',
'doubleredirects'       => 'Dvojitá přesměrování',
'doubleredirectstext'	=> '<b>Pozor:</b> Může se stát, že tento seznam bude obsahovat falešné pozitivy. Obvykle to znamená, že existuje další text s odkazy po #REDIRECT.<br />Každý řádek obsahuje odkaz na první a druhé přesměrování, plus první řádek textu druhého přesměrování, který obvykle ukazuje jméno „skutečného“ hlavního článku, na který by mělo první přesměrování odkazovat.',
'brokenredirects'       => 'Přerušená přesměrování',
'brokenredirectstext'   => ' Tato přesměrování vedou na neexistující články.',
'selflinks'             => 'Samoodkazující stránky',
'selflinkstext'         => 'Tyto stránky obsahují neužitečný odkaz samy na sebe.',
'mispeelings'           => 'Stránky s překlepy',
'mispeelingstext'       => ' Tyto stránky obsahují jeden z běžných překlepů, jejichž seznam je v $1. Měly by být opraveny na náležitý pravopis (uveden takto).',
'mispeelingspage'       => 'Seznam častých překlepů',
'missinglanguagelinks'  => 'Chybějící mezijazykové odkazy',
'missinglanguagelinksbutton'    => 'Nalézt chybějící mezijazykové odkazy pro',
'missinglanguagelinkstext'      => 'Těmto článkům chybí odkaz na ekvivalent v jazyce $1. Přesměrování a podstránky zde <i>nejsou</i> zobrazeny.',
'linkstodisambig' => 'Odkazy na rozcestníky',
'linkstodisambigtext' => 'Následující stránky odkazují na <i>stránku s rozcestníky</i>. Místo toho by měly by odkazovat na náležitou stránku.',

# Miscellaneous special pages
#
'orphans'               => 'Sirotci',
'geo'			=> 'Zeměpisné souřadnice',
'validate'		=> 'Prověřit stránku',
'lonelypages'   => 'Sirotčí články',
'uncategorizedpages'	=> 'Nekategorizované stránky',
'unusedimages'  => 'Nepoužívané obrázky a soubory',
'popularpages'  => 'Nejnavštěvovanější stránky',
'uncategorizedcategories' => 'Nekategorizované kategorie',
'nviews'                => '$1 zobrazení',
'wantedpages'   => 'Žádoucí články',
'nlinks'                => '$1 odkazů',					#TODO: plural
'allpages'              => 'Všechny stránky',
'nextpage'		=> 'Následující stránka ($1)',
'randompage'    => 'Náhodná stránka',
'randompage-url' => 'Speciální:Randompage',
'shortpages'    => 'Nejkratší články',
'longpages'             => 'Nejdelší články',
'deadendpages'  => 'Slepé články',
'listusers'             => 'Uživatelé',
'listadmins'    => 'Seznam správců',
'specialpages'  => 'Speciální stránky',
'spheading'             => 'Speciální stránky pro všechny uživatele',
'restrictedpheading'	=> 'Speciální stránky s omezeným přístupem',
/** obsoletes
'sysopspheading' => 'Speciální stránky pro správce',
'developerspheading' => 'Speciální stránky pro vývojáře',*/
'protectpage'   => 'Zamčení stránky',
'recentchangeslinked' => 'Související změny',
'rclsub'                => '(stránek odkazovaných z „$1“)',
'debug'                 => 'Odlaďování',
'newpages'              => 'Nejnovější články',
'ancientpages'		=> 'Nejdéle needitované stránky',
'intl'		=> 'Mezijazykové odkazy',
'move' => 'Přesunout',
'movethispage'  => 'Přesunout stránku',
'unusedimagestext' => '<p>Jiné WWW stránky mohou odkazovat přímo pomocí URL, na takové odkazy se v tomto seznamu nebere zřetel.',
'categoriespagetext' => 'Ve wiki existují následující kategorie:',
'booksources'   => 'Zdroje knih',
'booksourcetext' => 'Následují odkazy na jiné WWW stránky, na kterých se prodávají knihy, nebo které mohou obsahovat další informace o knize, kterou hledáte. {{SITENAME}} nemá s těmito prodejnami žádný vztah, tyto odkazy nelze chápat jako doporučení.', 
'data'	=> 'Data',
'userlevels'	=> 'Správa uživatelských práv',
'grouplevels' => 'Správa uživatelských skupin',
'isbn'  => 'ISBN',
'rfcurl' =>  'http://www.faqs.org/rfcs/rfc$1.html',
'pubmedurl' =>  'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=$1',
'alphaindexline' => 'od $1 do $2',
'version'               => 'Verze',
'asksqlpheading' => 'Úroveň pro přímé dotazy',
'blockpheading' => 'Úroveň pro blokování',
'createaccountpheading' => 'Úroveň pro tvorbu účtů',
'deletepheading' => 'Úroveň pro mazání',
'userrightspheading' => 'Úroveň pro přidělování uživatelských práv',
'grouprightspheading' => 'Úroveň pro přidělování práv skupinám',
'siteadminpheading' => 'Úroveň správce serveru',
'log'		=> 'Protokolovací záznamy',
'alllogstext'	=> 'Společné zobrazení knihy nahrávek, smazání, zamčení, zablokování a uživatelských práv.
Zobrazení můžete zůžit výběrem typu záznamu, uživatelského jména nebo dotčené stránky.',
# labels for User: and Title: on Special:Log pages
'specialloguserlabel' => 'Uživatel: ',
'speciallogtitlelabel' => 'Název: ',

# Special:Allpages
'nextpage'          => 'Další stránka ($1)',
'articlenamespace'  => '(články)',
'allpagesformtext1' => 'Zobrazit stránky počínaje od: $1',
'allpagesformtext2' => 'Jmenný prostor: $1 $2',
'allpagesnamespace' => 'Všechny stránky (jmenný prostor $1)',
'allpagesformtext' => '
<table border="0">
	<tr>
		<td align="right">Zobrazit stránky počínaje od:</td>
		<td align="left">$1</td>
	</tr>
	<tr>
		<td align="right">Jmenný prostor:</td>
		<td align="left">$2 $3</td>
	</tr>
	<tr>
		<td align="right">$4</td>
		<td align="left">V opačném pořadí</td>
	</tr>
</table>',
'allarticles'		=> 'Všechny články',
'allnonarticles'	=> 'Všechny nečlánky',
'allinnamespace'	=> 'Všechny stránky (jmenný prostor $1)',
'allnotinnamespace'	=> 'Všechny stránky (mimo jmenný prostor $1)',
'allpagesprev'		=> 'Předchozí',
'allpagesnext'		=> 'Nálsedující',
'allpagessubmit'	=> 'Přejít',

# Email this user
#
'mailnologin'   => 'Bez odesílací adresy',
'mailnologintext' => 'Pokud chcete posílat e-maily jiným uživatelům, musíte se <a href="{{localurle:Special:Userlogin}}">přihlásit</a> a mít platnou e-mailovou adresu ve svém <a href="{{localurle:Special:Preferences}}">nastavení</a>.',
'emailuser'             => 'Poslat e-mail',
'emailpage'             => 'Poslat e-mail',
'emailpagetext' => 'Pokud tento uživatel uvedl platnou e-mailovou adresu ve svém nastavení, tímto formulářem mu lze poslat zprávu. E-mailová adresa, kterou máte uvedenu v nastavení, se objeví jako adresa odesílatele pošty, aby adresát mohl odpovědět.',
'usermailererror' => 'Chyba poštovního programu: ',
'defemailsubject'  => 'E-mail {{grammar:2sg|{{SITENAME}}}}',
'noemailtitle'  => 'Bez e-mailové adresy',
'noemailtext'   => 'Tento uživatel buď nezadal platnou adresu nebo zakázal přijímat zprávy od jiných uživatelů.',
'emailfrom'             => 'Od',
'emailto'               => 'Komu',
'emailsubject'  => 'Předmět',
'emailmessage'  => 'Zpráva',
'emailsend'             => 'Odeslat',
'emailsent'             => 'Zpráva odeslána',
'emailsenttext' => 'Váš e-mail byl odeslán.',

# Watchlist
#
'watchlist'             => 'Sledované stránky',
'watchlistsub'	=> '(uživatele „$1“)',
'nowatchlist'   => 'Na svém seznamu sledovaných stránek nemáte žádné položky.',
'watchnologin'  => 'Nejste přihlášen(a)',
'watchnologintext'      => 'Pro sledování oblíbených stránek se musíte <a href="{{localurle:Special:Userlogin}}">přihlásit</a>.',
'addedwatch'    => 'Přidáno k oblíbeným',
'addedwatchtext' => 'Stránka „$1“ byla přidána mezi stránky, které <a href="{{localurle:Special:Watchlist}}">sledujete</a>. Budoucí změny této stránky se objeví <b>tučně</b> v <a href="{{localurle:Special:Recentchanges}}">seznamu posledních změn</a>, aby bylo snadnější si jí povšimnout. Pokud budete později chtít stránku ze seznamu sledovaných smazat, klikněte na „Nesledovat tuto stránku“ v liště nástrojů.',
'removedwatch'  => 'Vyřazeno ze seznamu sledovaných stránek',
'removedwatchtext' => 'Stránka „$1“ byla vyřazena z vašeho seznamu sledovaných stránek.',
'watch' => 'Sledovat',
'watchthispage' => 'Sledovat tuto stránku',
'unwatch' => 'Nesledovat',
'unwatchthispage' => 'Nesledovat tuto stránku',
'notanarticle'  => 'Toto není článek',
'watchnochange'         => 'Žádná ze sledovaných položek nebyla editována v době, která je zobrazena.',
'watchdetails'          => 'Počet sledovaných stránek nepočítaje diskusní: $1; můžete si nechat <a href="$4">ukázat a editovat kompletní seznam</a>. V období vybraném níže bylo provedeno $2 editací. $3…',
'watchmethod-recent'=> 'hledají se sledované stránky mezi posledními změnami',
'watchmethod-list'      => 'hledají se nejnovější editace sledovaných stránek',
'removechecked'         => 'Vyřadit označené položky ze seznamu sledovaných',
'watchlistcontains' => 'Počet stránek ve vašem seznamu sledovaných stránek: $1',
'watcheditlist'		=> 'Tady je abecední seznam vašich sledovaných stránek. Zaškrtněte stránky, které chcete smazat z vašeho seznamu a klikněte na tlačítko „vyřadit označené“ na konci obrazovky. S každou stránkou je vždy sledována i její diskusní stránka a naopak.',
'removingchecked' 	=> 'Požadované položky se odstraňují ze seznamu sledovaných…',
'couldntremove' 	=> 'Nepodařilo se odstranit položku „$1“…',
'iteminvalidname' 	=> 'Problém s položkou „$1“, neplatný název…',
'wlnote'                        => 'Níže je posledních $1 změn v posledních <b>$2</b> hodinách.',
'wlshowlast'            => 'Ukázat posledních $1 hodin $2 dnů $3',
'wlsaved'                       => 'Toto je uložená verze vašeho seznamu sledovaných stránek.',
'wlhideshowown'   	=> '$1 moje editace.',
'wlshow'		=> 'Zobrazit',
'wlhide'		=> 'Skrýt',

'updatedmarker'		=> '<span class=\'updatedmarker\'>&nbsp;změněno (od minulé návštěvy)&nbsp;</span>',

'email_notification_mailer' 		=> 'Zasílač hlášení {{grammar:2sg|{{SITENAME}}}}',
'email_notification_infotext' 		=> 'Zasílání hlášení je zapnuto.
Při každé změně vámi sledované stránky vám bude zaslán e-mail.',
'email_notification_reset'			=> 'Vynulovat všechny příznaky (nastavit stav na „navštíveno“)',
'email_notification_newpagetext'=> 'Toto je nová stránka.',
'email_notification_to' 	=> '$WATCHINGUSERNAME_QP <$WATCHINGUSEREMAILADDR>',
'email_notification_subject' 	=> '$PAGEEDITOR upravil stránku $PAGETITLE na {{grammar:6sg|{{SITENAME}}}}.',
'email_notification_lastvisitedrevisiontext' => 'Vizte {{SERVER}}{{localurl:$PAGETITLE_RAWURL|diff=0&oldid=$OLDID}} pro seznam všech změn od minulé návštěvy.',
'email_notification_body' => 'Vážený uživateli $WATCHINGUSERNAME,

$PAGEEDITDATE upravil $PAGEEDITOR stránku $PAGETITLE,
vizte {{SERVER}}{{localurl:$PAGETITLE_RAWURL}} pro aktuální verzi.

$NEWPAGE

Shrnutí editace: $PAGESUMMARY $PAGEMINOREDIT
Uživatele, který změnu provedl, můžete kontaktovat:
e-mailem: {{SERVER}}{{localurl:Special:Emailuser|target=$PAGEEDITOR_RAWURL}}
na wiki: {{SERVER}}{{localurl:User:$PAGEEDITOR_RAWURL}}

Dokud stránku nenavštívíte, nebudou vám zasílána další oznámení o změnách této stránky,
případně do doby, než vynulujete příznaky ve svém seznamu sledovaných stránek.

	S pozdravem váš zasílač hlášení {{grammar:2sg|{{SITENAME}}}}

--
Pro změnu nastavení navštivte
{{SERVER}}{{localurl:Special:Watchlist|magic=yes}}

Rady a kontakt:
{{SERVER}}{{localurl:Project:Potřebuji pomoc}}',

# Delete/protect/revert
#
'deletepage'    => 'Smazat stránku',
'confirm'               => 'Potvrdit',
'excontent' => 'obsah byl:',
'exbeforeblank' => 'obsah před vyprázdněním byl:',
'exblank' => 'stránka byla prázdná',
'confirmdelete' => 'Potvrdit smazání',
'deletesub'		=> '(Maže se „$1“)',
'historywarning' => ' Varování: Stránka, kterou chcete smazat, má historii:&nbsp;',
'confirmdeletetext' => 'Chystáte se trvale smazat z databáze stránku nebo obrázek s celou jeho historií. Prosím potvrďte, že to opravdu chcete učinit, že si uvědomujete důsledky a že je to v souladu s [[Project:Pravidla|pravidly]].',
'confirmcheck'  => 'Ano, opravdu to chci smazat.',
'actioncomplete' => 'Provedeno',
'deletedtext'	=> ' Stránka nebo soubor „$1“ byla smazána; $2 zaznamenává poslední smazání.',
'deletedarticle' => 'maže „$1“',
'dellogpage'    => 'Kniha_smazaných_stránek',
'dellogpagetext' => 'Zde je seznam posledních smazaných z databáze. Všechny časové údaje uvedeny podle časového pásma serveru (UTC).
<ul>
</ul>
',
'deletionlog'   => 'kniha smazaných stránek',
'reverted'              => 'Obnovení předchozí verze',
'deletecomment' => 'Důvod smazání',
'imagereverted' => 'Obnovení předchozí verze úspěšně provedeno.',
'rollback'              => 'Vrátit zpět editace',
'rollback_short' => 'Vrátit zpět',
'rollbacklink'  => 'vrácení zpět',
'rollbackfailed' => 'Nešlo vrátit zpět',
'cantrollback'  => 'Nelze vrátit zpět poslední editaci, neboť poslední přispěvatel je jediným autorem tohoto článku.',
'alreadyrolled' => 'Nelze vrátit zpět poslední editaci [[$1]] od [[User:$2|$2]] ([[User talk:$2|Diskuse]]), protože někdo jiný již článek editoval nebo vrátil tuto změnu zpět. Poslední editace byla od [[User:$3|$3]] ([[User talk:$3|Diskuse]]).',
#   only shown if there is an edit comment
'editcomment' => 'Shrnutí editace bylo: „<i>$1</i>“.',
'revertpage'	=> 'Editace uživatele „$2“ vrácena do předchozího stavu, jehož autorem je „$1“.',
'sessionfailure' => 'Zřejmě je nějaký problém s vaším přihlášením;
vámi požadovaná činnost byla stornována jako prevence před neoprávněným přístupem.
Stiskněte tlačítko „zpět“, obnovte stránku, ze které jste přišli a zkuste činnost znovu.',
'protectlogpage' => 'Kniha_zamčení',
'protectlogtext' => 'Zde je seznam zamčení/odemčení stránek. Viz [[{{ns:4}}:Zamčená stránka]] pro další informace.',
'protectedarticle' => 'zamyká „[[$1]]“',
'unprotectedarticle' => 'odemyká „[[$1]]“',
'protectsub' =>'(Zamyká se „$1“)',
'confirmprotecttext' => 'Opravdu chcete zamknout tuto stránku?',
'confirmprotect' => 'Potvrdit zamčení',
'protectmoveonly' => 'Bránit pouze proti přesunutí',
'protectcomment' => 'Důvod zamčení',
'unprotectsub' => '(Odemyká se „$1“)',
'confirmunprotecttext' => 'Opravdu chcete odemknout tuto stránku?',
'confirmunprotect' => 'Potvrdit odemčení',
'unprotectcomment' => 'Důvod odemčení',
'protectreason' => '(udejte důvod)',

# Undelete
'undelete' => 'Obnovit smazanou stránku',
'undeletepage' => 'Prohlédnout si a obnovit smazanou stránku',
'undeletepagetext' => 'Tyto stránky jsou smazány, avšak dosud archivovány, a proto je možno je obnovit. Archiv může být pravidelně vyprazdňován.',
'undeletearticle' => 'Obnovit smazaný článek',
'undeleterevisions' => '$1 verzí je archivováno',
'undeletehistory' => 'Pokud stránku obnovíte, všechny revise budou v historii obnoveny. Pokud byla vytvořena nová stránka se stejným jménem jako smazaná, obnovené revise se zapíší na starší místo v historii a nová stránka nebude nahrazena.',
'undeleterevision' => 'Smazaná verze z $1',
'undeletebtn' => 'Obnovit',
'undeletedarticle' => 'obnovuje „$1“',
'undeletedrevisions' => 'Obnoveno $1 verzí',
'undeletedtext'   => 'Stránka [[$1]] byla úspěšně obnovena. Vizte [[Special:Log/delete|knihu smazaných stránek]] na záznam posledních smazání a obnovení.',

# Contributions
#
'contributions' => 'Příspěvky uživatele',
'mycontris'             => 'Mé příspěvky',
'contribsub'    => '$1',
'contributionsformtext' => '
<table border="0">
        <tr>
                <td align="right">Jmenný prostor:</td>
                <td align="left">$1 $2</td>
        </tr>
	<tr>
		<td align="right">$3</td>
		<td>V opačném pořadí</td>
	</tr>
</table>',
'nocontribs'    => 'Nenalezeny žádné změny podle těchto kritérií.',
'ucnote'                => 'Níže jsou uživatelovy poslední <strong>$1</strong> změny během posledních <strong>$2</strong> dnů.',
'uclinks'               => 'Ukaž posledních $1 změn; ukaž posledních $2 dnů.',
'uctop'                 => ' (aktuální)',
'newbies'       => 'nováčci',

# What links here
#
'whatlinkshere' => 'Odkazuje sem',
'notargettitle' => 'Bez cílové stránky',
'notargettext'  => 'Této funkci musíte určit cílovou stránku nebo uživatele.',
'linklistsub'   => '(Seznam odkazů)',
'linkshere'             => 'Odkazují sem tyto stránky:',
'nolinkshere'   => 'Žádná stránka sem neodkazuje.',
'isredirect'    => 'přesměrování',

# Block/unblock IP
#
'blockip'               => 'Zablokovat uživatele',
'blockiptext'   => 'Tento formulář slouží k zablokování editací z konkrétní IP adresy nebo uživatelského jména. Toto by mělo být používáno jen v souladu s [[{{ns:4}}:blokování|pravidly blokování]]. Udejte přesný důvod níže (například ocitujte, které stránky byly poškozeny). Čas pro vypršení se udává ve standardním formátu GNU, který je popsán na [http://www.gnu.org/software/tar/manual/html_chapter/tar_7.html tar manual], např. „1 hour“, „2 days“, „next Wednesday“, „1 January 2017“. Alternativně můžete použít „indefinite“ (na dobu neurčitou) nebo „infinite“ (navždy). Pro informaci, jak zablokovat rozsah adres, se podívejte na [[meta:Range blocks]]. Pro odblokování se podívejte na [[Special:Ipblocklist|seznam blokovaných IP adres]].',
'ipaddress'			  => 'IP adresa',
'ipadressorusername' => 'IP adresa nebo uživatelské jméno',		#TODO: remove
'ipaddressorusername' => 'IP adresa nebo uživatelské jméno',
'ipbexpiry'             => 'Vyprší',
'ipbreason'             => 'Důvod',
'ipbsubmit'             => 'Zablokovat',
'badipaddress'  => 'Neplatná IP adresa',
'noblockreason' => 'Nutno uvést důvod zablokování.',
'blockipsuccesssub' => 'Zablokování uspělo',
'blockipsuccesstext' => 'Uživatel „$1“ je zablokován. <br />Podívejte se na [[Special:Ipblocklist|seznam zablokovaných]], [[Project:Kniha zablokování]] zaznamenává všechny podobné úkony.',
'unblockip'             => 'Odblokovat IP adresu',
'unblockiptext' => 'Tímto formulářem je možno obnovit právo blokované IP adresy či uživatele opět přispívat do {{grammar:2sg|{{SITENAME}}}}.',
'ipusubmit'             => 'Odblokovat',
'ipusuccess'	=> 'IP adresa „[[$1]]“ byla úspěšně odblokována',
'ipblocklist'   => 'Seznam blokovaných IP adres',
'blocklistline' => '$1 $2 zablokoval $3 (čas vypršení: $4)',
'blocklink'             => 'zablokovat',
'unblocklink'   => 'uvolnit',
'contribslink'  => 'příspěvky',
'autoblocker'	=> 'Automaticky zablokováno, protože sdílíte IP adresu s „$1“. Důvod: „$2“.',
'blocklogpage'	=> 'Kniha_zablokování',
'blocklogentry'	=> 'zablokovává „[[$1]]“ s časem vypršení $2',
'blocklogtext'	=> 'Toto je kniha úkonů blokování a odblokování uživatelů. Automaticky blokované IP adresy nejsou vypsány. Podívejte se na [[Special:Ipblocklist|seznam blokování IP]] s výčtem aktuálních zákazů a blokování.',
'unblocklogentry'	=> 'odblokovává „$1“',
'range_block_disabled'  => 'Blokování rozsahů IP adres je zakázáno.',
'ipb_expiry_invalid'    => 'Neplatný čas vypršení.',
'ip_range_invalid'      => 'Neplatný IP rozsah.',
'proxyblocker'  => 'Blokování proxy serverů',
'proxyblockreason'      => 'Vaše IP adresa byla zablokována, protože funguje jako otevřený proxy server. Kontaktujte prosím vašeho poskytovatele Internetového připojení nebo technickou podporu a informujte je o tomto vážném bezpečnostním problému.',
'proxyblocksuccess'     => 'Hotovo.',
'sorbs'         => 'SORBS DNSBL',
'sorbsreason'   => 'Vaše IP adresa je uvedena na seznamu [http://www.sorbs.net SORBS] DNSBL jako [[w:cs:otevřená proxy|otevřená proxy]].',

# Developer tools
#
'lockdb'                => 'Zamknout databázi',
'unlockdb'              => 'Odemknout databázi',
'lockdbtext'    => 'Pokud zamknete databázi, znemožníte ostatním editovat, upravovat nastavení, sledované stránky apod. Potvrďte, že to opravdu chcete udělat a že odemknete databázi hned po opravách.',
'unlockdbtext'  => ' Pokud odemknete databázi, umožníte ostatním editovat, upravovat nastavení, sledované stránky apod. Potvrďte, že to opravdu chcete udělat.',
'lockconfirm'   => 'Ano, opravdu chci zamknout databázi.',
'unlockconfirm' => 'Ano, opravdu chci odemknout databázi.',
'lockbtn'               => 'Zamknout databázi',
'unlockbtn'             => 'Odemknout databázi',
'locknoconfirm' => 'Nebylo zaškrtnuto políčko potvrzení.',
'lockdbsuccesssub' => 'Databáze uzamčena',
'unlockdbsuccesssub' => 'Databáze odemčena',
'lockdbsuccesstext' => 'Databáze {{grammar:2sg|{{SITENAME}}}} byla úspěšně uzamčena.
<br />Nezapomeňte ji po opravách odemknout.',
'unlockdbsuccesstext' => 'Databáze {{grammar:2sg|{{SITENAME}}}} je odemčena.',

# SQL query
#
'asksql'                => 'SQL dotaz',
'asksqltext'    => 'Pomocí tohoto formuláře lze provést přímý dotaz do databáze.
Pro řetězcové literály použijte apostrofy (\'takto\').
Tato funkce může výrazně zatěžovat server, proto ji používejte s rozvahou.',
'sqlislogged'   => 'Uvědomte si prosím, že všechny dotazy se zaznamenávají.',
'sqlquery'              => 'Zadejte dotaz',
'querybtn'              => 'Provést',
'selectonly'    => 'Povoleny jsou dotazy pouze pro čtení.',
'querysuccessful' => 'Dotaz úspěšně proveden.',

# Make sysop
'makesysoptitle'        => 'Učinit uživatele správcem',
'makesysoptext'         => 'Tento formulář je používán byrokraty pro změnu obyčejného uživatele na správce. Vepište jméno uživatele do políčka a stiskněte tlačítko.',
'makesysopname'         => 'Jméno uživatele:',
'makesysopsubmit'       => 'Učinit tohoto uživatele správcem',
'makesysopok'		=> '<b>Uživatel „$1“ nyní patří mezi správce</b>',
'makesysopfail'		=> '<b>Uživatel „$1“ nemůže být učiněn správcem. (Vložili jste jeho jméno správně?)</b>',
'setbureaucratflag' => 'Nastavit příznak byrokrata',
'bureaucratlog'		=> 'Kniha_byrokratů',
'rightslogtext'		=> 'Toto je záznam změn uživatelských oprávnění.',
'bureaucratlogentry'	=> 'Oprávnění pro uživatele „$1“ nastavena na „$2“.',
'rights'			=> 'Oprávnění:',
'set_user_rights'	=> 'Nastavit uživatelova oprávnění',
'user_rights_set'	=> '<b>Uživatelova práva k „$1“ aktualizována</b>',
'set_rights_fail'	=> '<b>Uživatelova práva k „$1“ nemohla být nastavena. (Vložili jste jeho jméno správně?)</b>',
'makesysop'         => 'Učinit uživatele správcem',
'already_sysop'     => 'Tento uživatel už je správce.',
'already_bureaucrat' => 'Tento uživatel už je byrokrat.',

# Validation
'val_yes' => 'Ano',
'val_no' => 'Ne',
'val_revision' => 'Verze',
'val_time' => 'Čas',
'val_list_header' => '<th>#</th><th>Téma</th><th>Rozsah</th><th>Činnost</th>',
'val_add' => 'Přidat',
'val_del' => 'Smazat',
'val_warning' => '<b><i>Absolutně</i> nikdy tady nic neměňte bez <i>výslovné</i> shody v komunitě!</b>',
'val_rev_for' => 'Verze ',
'val_rev_stats_link' => 'Statistiky hodnocení pro „$1“ vizte <a href="$2">zde</a>',
'val_iamsure' => 'Jste si opravdu jisti?',
'val_clear_old' => 'Smazat moje starší hodnocení pro $1',
'val_merge_old' => 'Použít moje předchozí hodnocení tam, kde jsem zvolil „Bez názoru“',
'val_form_note' => '<b>Rada:</b> Sloučení údajů znamená, že zvolené verze článku,
které jsou označeny jako <i>bez názoru</i>, budou nastaveny na hodnotu a komentář
nejnovější verze, pro kterou jste názor vyjádřil(a). Pokud například chcete
změnit v nové verzi jedinou hodnotu, ale ostatní chcete ponechat, vyberte
pouze tu hodnotu, kterou chcete <i>změnit</i>. Sloučením se vyplní ostatní
hodnoty jejich předešlým nastavením.',
'val_noop' => 'Bez názoru',
'val_percent' => '<b>$1%</b><br />($2 / $3 bodů<br />$4 uživatelů)',			#TODO: plural
'val_percent_single' => '<b>$1%</b><br />($2 / $3 bodů<br />jeden uživatel)',	#TODO: plural
'val_total' => 'Celkem',
'val_version' => 'Verze',
'val_tab' => 'Schválit',
'val_this_is_current_version' => 'toto je nejnovější verze',
'val_version_of' => 'Verze z $1',
'val_table_header' => "<tr><th>Třída</th>$1<th colspan=4>Názor</th>$1<th>Komentář</th></tr>\n",
'val_stat_link_text' => 'Statistiky hodnocení tohoto článku',
'val_view_version' => 'Prohlédnout tuto verzi',
'val_validate_version' => 'Hodnotit tuto verzi',
'val_user_validations' => 'Tento uživatel zhodnotil $1 stran.',					#TODO: plural
'val_no_anon_validation' => 'Pro hodnocení článků musíte být přihlášen(a).',
'val_validate_article_namespace_only' => 'Hodnotit lze pouze články. Tato stránka <i>není</i> ve jmenném prostoru článků.',
'val_validated' => 'Hodnocení uloženo.',
'val_article_lists' => 'Seznam zhodnocených článků',
'val_page_validation_statistics' => 'Statistiky hodnocení pro $1',

# Move page
#
'movepage'              => 'Přesunout stránku',
'movepagetext'  => 'Pomocí tohoto formuláře změníte název stránky a přesunete i celou její historii pod nový název. Původní název se stane přesměrováním na nový název. Odkazy na předchozí název <i>nebudou</i> změněny. <b>VAROVÁNÍ!</b> Toto může drastická a nečekaná změna pro oblíbené stránky. Ujistěte se, prosím, že chápete důsledky vašeho kroku před tím, než změnu provedete.',
'movepagetalktext' => "Přidružená diskusní stránka, pokud existuje, bude automaticky přesunuta společně se stránkou, '''pokud:'''
* Nepřesouváte stránku napříč jmennými prostory,
* Již neexistuje neprázdná diskusní stránka pod novým jménem, nebo
* Nezrušíte křížek ve formuláři.

V těchto případech musíte přesunout nebo sloučit stránky manuálně, jestliže si to přejete.",
'movearticle'   => 'Přesunout stránku',
'movenologin' => 'Nejste přihlášen(a)!',
'movenologintext'       => 'Pro přesouvání stránek se musíte <a href="{{localurle:Special:Userlogin}}">přihlásit</a>.',
'newtitle'              => 'Na nový název',
'movepagebtn'   => 'Přesunout stránku',
'pagemovedsub'  => 'Úspěšně přesunuto',
'pagemovedtext' => "Stránka „[[$1]]“ přesunuta na „[[$2]]“.

'''Nyní''' následujte odkaz [[Speciální:Whatlinkshere/$1]]: pokud se v seznamu vyskytnou nějaké přesměrovače, je třeba je upravit tak, aby ukazovaly na nový název ($2), jinak nebudou fungovat.",
'articleexists' => 'Takto nazvaná stránka již existuje, nebo Vámi zvolený název je neplatný. Zvolte jiný název.',
'talkexists'	=> 'Stránka byla přesunuta úspěšně, ale diskusní stránka přesunuta být nemohla, neboť pod novým názvem již nějaká stránka existuje. Proveďte prosím ruční sloučení.',
'movedto'               => 'přesunuto na',
'movetalk'              => 'Přesunout také diskusní stránku, existuje-li.',
'talkpagemoved' => 'Diskusní stránka byla také přesunuta.',
'talkpagenotmoved' => 'Diskusní stránka <strong>nebyla</strong> přesunuta.',
'1movedto2'             => 'Stránka [[$1]] přemístěna na stránku [[$2]]',
'1movedto2_redir' => 'Stránka [[$1]] přemístěna na stránku [[$2]] s výměnou přesměrování',
'movelogpage' => 'Kniha přesunů',
'movelogpagetext' => 'Toto je záznam všech přesunů stránek.',
'movereason'	=> 'Důvod',
'revertmove'	=> 'vrátit',
'delete_and_move' => 'Smazat a přesunout',
'delete_and_move_text'	=> 
'==Je potřeba smazání==

Cílová stránka „[[$1]]“ již existuje. Přejete si ji smazat pro uvolnění místa pro přesun?',
'delete_and_move_reason' => 'Smazáno pro umožnění přesunu',

# Export

'export'                => 'Exportovat stránky',
'exporttext'    => 'Můžete exportovat text a historii editací některé stránky nebo sady stránek zabalené v XML; to může být importováno do jiné wiki, která běží na software MediaWiki, tranformováno nebo jen uschováno pro vaši soukromou potřebu.',
'exportcuronly' => 'Zahrnout jen současnou verzi, ne plnou historii',

# Namespace 8 related

'allmessages'   => 'Všechna systémová hlášení',
'allmessagesname' => 'Označení hlášení',
'allmessagesdefault' => 'Původní text',
'allmessagescurrent' => 'Aktuální text',
'allmessagestext'       => 'Toto je seznam všech hlášení dostupných ve jmenném prostoru MediaWiki.',
'allmessagesnotsupportedUI' => 'Váš aktuální jazyk rozhraní <b>$1</b> není na tomto serveru pro {{ns:-1}}:AllMessages podporován.',
'allmessagesnotsupportedDB' => '{{ns:-1}}:AllMessages není podporováno, neboť wgUseDatabaseMessages je vypnuto.',

# Thumbnails

'thumbnail-more'        => 'Zvětšit',
'missingimage'          => "<b>Chybějící obrázek</b><br /><i>$1</i>\n",
'filemissing'		=> 'Chybějící soubor',

# Special:Import
'import'        => 'Importovat stránky',
'importtext'    => 'Prosím exportujte soubor ze zdrojové wiki pomocí nástroje {{ns:-1}}:Export, uložte ji na svůj disk a nahrajte ji sem.',
'importfailed'  => 'Import selhal: $1',
'importnotext'  => 'Prázdný nebo žádný text',
'importsuccess' => 'Import byl úspěšný!',
'importhistoryconflict' => 'Existuje konflikt mezi historiemi verzí. Možná, že tato stránka byla již importována dříve.',

# Keyboard access keys for power users
'accesskey-search' => 'f',
'accesskey-minoredit' => 'i',
'accesskey-save' => 's',
'accesskey-preview' => 'p',
'accesskey-diff' => 'd',
'accesskey-compareselectedversions' => 'v',

# tooltip help for some actions, most are in Monobook.js
'tooltip-search' => 'Hledat na této wiki [alt-f]',
'tooltip-minoredit' => 'Označit jako malou editaci [alt-i]',
'tooltip-save' => 'Uložit vaše úpravy [alt-s]',
'tooltip-preview' => 'Prohlédnout vaše úpravy, prosíme použijte tuto funkci před uložením! [alt-p]',
'tooltip-diff' => 'Zobrazit, jaké změny jste v textu provedli. [alt-d]',
'tooltip-compareselectedversions' => 'Porovnat rozdíly mezi zvolenými verzemi této stránky. [alt-v]',
'tooltip-watch' => 'Přidat stránku do seznamu sledovaných [alt-w]',

# stylesheets

'Monobook.css' => '/* editací tohoto souboru upravíte styl "monobook" pro celou {{grammar:4sg|{{SITENAME}}}} */',

# Metadata
'nodublincore' => 'Na tomto serveru je vypnuto generování metadat Dublin Core RDF.',
'nocreativecommons' => 'Na tomto server je vypnuto generování metadat Creative Commons RDF.',
'notacceptable' => 'Tento wiki server není schopen poskytnout data ve formátu, který by váš klient byl schopen přečíst.',

# Attribution

'anonymous' => "Anonymní uživatel(é) $wgSitename",
'siteuser' => "Uživatel $wgSitename $1",
'lastmodifiedby' => 'Tuto stránku naposledy měnil $2 v $1.',
'and' => 'a',
'othercontribs' => 'Založeno na textu od uživatele $1.',
'others' => 'další',
'siteusers' => "Uživatel(é) $wgSitename $1",
'creditspage' => 'Zásluhy za stránku',
'nocredits' => 'K této stránce neexistuje informace o zásluhách.',

# Spam protection

'spamprotectiontitle' => 'Spam protection filter',
'spamprotectiontext' => 'Stránka, kterou jste se pokusil(a) uložit, byla zablokována protispamovým filtrem. Pravděpodobnou příčinou je odkaz na externí stránky. Může vás zajímat následující regulární výraz, který označuje v současné době blokované stránky:',
'spamprotectionmatch' => 'Následující text spustil náš filtr proti spamu: $1',

# Categories

'subcategorycount' => 'Počet podkategorií v této kategorii: $1',
'subcategorycount1' => 'V této kategorii je $1 podkategorie.',
'categoryarticlecount' => 'Počet článků v této kategorii: $1',
'categoryarticlecount1' => 'V této kategorii je $1 článek.',
'usenewcategorypage' => "1\n\nK vypnutí nového vzhledu stránek kategorií nastavte první znak na '0'.",
'listingcontinuesabbrev' => 'pokrač.',

# Info page
'infosubtitle' => 'Informace o stránce',
'numedits' => 'Počet editací (článek): ',
'numtalkedits' => 'Počet editací (diskusní stránka): ',
'numwatchers' => 'Počet sledujících uživatelů: ',
'numauthors' => 'Počet různých autorů (článek): ',
'numtalkauthors' => 'Počet rozdílných autorů (diskusní stránka): ',

# Math options
'mw_math_png' => 'Vždy jako PNG',
'mw_math_simple' => 'Jednoduché jako HTML, jinak PNG',
'mw_math_html' => 'HTML pokud je to možné, jinak PNG',
'mw_math_source' => 'Ponechat jako TeX (pro textové prohlížeče)',
'mw_math_modern' => 'Doporučené nastavení pro moderní prohlížeče',
'mw_math_mathml' => 'MathML pokud je podporováno (experimentální)',

# Patrolling
'markaspatrolleddiff'   => 'Označit jako prověřené',
'markaspatrolledlink'   => '<div class="patrollink">[$1]</div>',
'markaspatrolledtext'   => 'Označit tento článek jako prověřený',
'markedaspatrolled'     => 'Označeno jako prověřené',
'markedaspatrolledtext' => 'Vybraná verze byla označena jako prověřená.',
'rcpatroldisabled'      => 'Hlídka posledních změn vypnuta',
'rcpatroldisabledtext'  => 'Hlídka posledních změn je momentálně vypnuta.',

# Monobook.js: tooltips and access keys for monobook
'Monobook.js' => "/* tooltips and access keys */
ta = new Object();
ta['pt-userpage'] = new Array('.','Moje uživatelská stránka');
ta['pt-anonuserpage'] = new Array('.','Uživatelská stránka pro IP adresu, ze které editujete');
ta['pt-mytalk'] = new Array('n','Moje diskusní stránka');
ta['pt-anontalk'] = new Array('n','Diskuse o editacích provedených z této IP adresy');
ta['pt-preferences'] = new Array('','Moje preference');
ta['pt-watchlist'] = new Array('l','Seznam stránek, jejichž změny sleduji');
ta['pt-mycontris'] = new Array('y','Seznam mých příspěvků');
ta['pt-login'] = new Array('o','Doporučujeme vám přihlásit se, ovšem není to povinné.');
ta['pt-anonlogin'] = new Array('o','Doporučujeme vám přihlásit se, ovšem není to povinné.');
ta['pt-logout'] = new Array('o','Odhlásit se');
ta['ca-talk'] = new Array('t','Diskuse ke stránce');
ta['ca-edit'] = new Array('e','Tuto stránku můžete editovat. Prosíme použijte tlačítko Ukázat náhled před uložením.');
ta['ca-addsection'] = new Array('+','Přidat k této diskusi svůj komentář.');
ta['ca-viewsource'] = new Array('e','Tato stránka je zamčena. Můžete si prohlédnout její zdrojový kód.');
ta['ca-history'] = new Array('h','Starší verze této stránky.');
ta['ca-protect'] = new Array('=','Zamknout tuto stránku.');
ta['ca-delete'] = new Array('d','Smazat tuto stránku.');
ta['ca-undelete'] = new Array('d','Obnovit editace této stránky provedené před jejím smazáním.');
ta['ca-move'] = new Array('m','Přesunout tuto stránku');
ta['ca-nomove'] = new Array('','Nemáte oprávnění přesunout tuto stránku');
ta['ca-watch'] = new Array('w','Přidat tuto stránku mezi sledované');
ta['ca-unwatch'] = new Array('w','Vyjmout tuto stránku ze sledovaných');
ta['search'] = new Array('f','Hledat na této wiki');
ta['p-logo'] = new Array('','Hlavní strana');
ta['n-mainpage'] = new Array('z','Navštívit Hlavní stranu');
ta['n-portal'] = new Array('','O projektu, jak můžete pomoci, kde hledat');
ta['n-currentevents'] = new Array('','Informace o aktuálních událostech');
ta['n-recentchanges'] = new Array('r','Seznam posledních změn na této wiki');
ta['n-randompage'] = new Array('x','Přejít na náhodně vybranou stránku');
ta['n-help'] = new Array('','Místo, kde najdete pomoc');
ta['n-sitesupport'] = new Array('','Podpořte nás');
ta['t-whatlinkshere'] = new Array('j','Seznam všech wikistránek, které sem odkazují');
ta['t-recentchangeslinked'] = new Array('k','Nedávné změny stránek, které sem odkazují');
ta['feed-rss'] = new Array('','RSS kanál pro tuto stránku');
ta['feed-atom'] = new Array('','Atom kanál pro tuto stránku');
ta['t-contributions'] = new Array('','Prohlédnout si seznam příspěvků tohoto uživatele');
ta['t-emailuser'] = new Array('','Poslat e-mail tomuto uživateli');
ta['t-upload'] = new Array('u','Nahrát obrázky či jiná multimédia');
ta['t-specialpages'] = new Array('q','Seznam všech speciálních stránek');
ta['ca-nstab-main'] = new Array('c','Zobrazit článek');
ta['ca-nstab-user'] = new Array('c','Zobrazit uživatelovu stránku');
ta['ca-nstab-media'] = new Array('c','Zobrazit stránku souboru');
ta['ca-nstab-special'] = new Array('','Toto je speciální stránka, kterou nelze editovat.');
ta['ca-nstab-wp'] = new Array('a','Zobrazit stránku o wiki.');
ta['ca-nstab-image'] = new Array('c','Zobrazit stránku obrázku.');
ta['ca-nstab-mediawiki'] = new Array('c','Zobrazit systémovou zprávu.');
ta['ca-nstab-template'] = new Array('c','Zobrazit šablonu.');
ta['ca-nstab-help'] = new Array('c','Zobrazit stránku nápovědy.');
ta['ca-nstab-category'] = new Array('c','Zobrazit kategorii.');",

# preferences
'tog-hover'                     => 'Zobrazovat bublinu (hoverbox) nad wiki odkazy',
'tog-underline'                 => 'Podtrhnout odkazy',
'tog-highlightbroken'           => 'Formátovat odkazy na neexistující články <a href="#" class="new">takto</a> (alternativa: takto<a href="#" class="broken">?</a>).',
'tog-justify'                   => 'Zarovnat odstavce do bloku',
'tog-hideminor'                 => 'Skrýt malé editace v posledních změnách',
'tog-usenewrc'                  => 'Zdokonalené poslední změny (JavaScript)',
'tog-numberheadings'            => 'Automaticky číslovat nadpisy',
'tog-showtoolbar'               => 'Ukázat lištu s nástroji při editaci',
'tog-editondblclick'            => 'Editovat dvojklikem (JavaScript)',
'tog-editsection'               => 'Zapnout možnost editace části článku pomocí odkazu [editovat]',
'tog-editsectiononrightclick'   => 'Zapnout možnost editace části článku pomocí kliknutí pravým tlačítkem na nadpisy v článku (JavaScript)',
'tog-showtoc'                   => 'Ukázat obsah článku (pokud má článek více než tři nadpisy)',
'tog-rememberpassword'          => 'Pamatovat si mé heslo mezi návštěvami',
'tog-editwidth'                 => 'Roztáhnout editační okno na celou šířku',
'tog-watchdefault'              => 'Přidat editace ke sledovaným článkům',
'tog-minordefault'              => 'Označit editaci implicitně jako malá editace',
'tog-previewontop'              => 'Zobrazovat náhled před editačním oknem (ne za ním)',
'tog-previewonfirst'			=> 'Zobrazit při první editaci náhled',
'tog-nocache'                   => 'Nepoužívat cache',
'tog-fancysig'	                => 'Neupravovat podpis (nevkládat automaticky odkaz)',
'tog-enotifwatchlistpages' 		=> 'Poslat e-mail při změnách stránky (poznámka: existující příznaky musí být v seznamu sledovaných odstraněny ručně)',
'tog-enotifusertalkpages' 		=> 'Poslat e-mail při změnách mé diskusní stránky (poznámka: existující příznaky musí být v seznamu sledovaných odstraněny ručně)',
'tog-enotifminoredits' 			=> 'Poslat e-mail i pro menší editace (které jinak nezpůsobují odeslání e-mailu)',
'tog-enotifrevealaddr' 			=> 'Prozradit mou e-mailovou adresu v upozorňujících e-mailech (při mých změnách to umožňuje sledujícím uživatelům rychle mi odpovědět)',
'tog-shownumberswatching' 		=> 'Zobrazovat počet sledujících uživatelů (v posledních změnách, sledovaných stránkách a patičkách stránek',
'tog-rcusemodstyle' 			=> 'Zobrazovat poslední změny jako UseMod: zobrazena je pouze poslední změna každé stránky',
'tog-showupdated'				=> 'Zobrazit značku úprav',
'tog-externaleditor'			=> 'Implicitně používat externí editor',
'tog-externaldiff'				=> 'Implicitně používat externí porovnávací program',

# image deletion
'deletedrevision' => 'Smazána stará verze $1.',

# browsing diffs
'previousdiff' => '&larr; Předchozí porovnání',
'nextdiff' => 'Následující porovnání &rarr;',

'imagemaxsize' => 'Omezit obrázky na stránkách s popiskem na: ',
'thumbsize'	=> 'Velikost náhledu: ',
'showbigimage' => 'Stáhnout verzi s vysokým rozlišením ($1&times;$2, $3 KB)',

'newimages' => 'Galerie nových obrázků',
'noimages'  => 'Není co zobrazit.',

'sitesettings'                  => 'Nastavení serveru',
'sitesettings-features'         => 'Schopnosti',
'sitesettings-permissions'      => 'Oprávnění',
'sitesettings-memcached'        => 'Démon Memcache',
'sitesettings-debugging'        => 'Ladění',
'sitesettings-caching'          => 'Stránková cache',
'sitesettings-wgShowIPinHeader' => 'Zobrazovat v záhlaví IP adresu (pro nepřihlášené uživatele)',
'sitesettings-wgUseDatabaseMessages' => 'Používat zprávy rozhraní z databáze',
'sitesettings-wgUseCategoryMagic' => 'Zapnout kategorie',
'sitesettings-wgUseCategoryBrowser' => 'Zapnout experimentální procházení kategoriemi ve stylu dmoz. Výstup vypadá asi takto: Encyklopedie > Hudba > Hudební styly > Jazz',
'sitesettings-wgHitcounterUpdateFreq' => 'Frekvence aktualizací čítače návštěv',
'sitesettings-wgAllowExternalImages' => 'Povolit použití externích obrázků v článcích',
'sitesettings-permissions-readonly' => 'Režim údržby: Zakázat zápis',
'sitesettings-permissions-whitelist' => 'Režim whitelist',
'sitesettings-permissions-banning' => 'Blokování uživatelů',
'sitesettings-permissions-miser' => 'Nastavení výkonu',
'sitesettings-wgReadOnly' => 'Režim pouze pro čtení',
'sitesettings-wgReadOnlyFile' => 'Soubor se zprávou režimu pouze pro čtení',
'sitesettings-wgWhitelistEdit' => 'Uživatelé se musí přihlásit, aby mohli editovat',
'sitesettings-wgWhitelistRead' => 'Anonymní uživatelé mohou číst pouze tyto stránky:',
'sitesettings-wgWhitelistAccount-user' => 'Uživatelé si mohou sami vyrábět účty',
'sitesettings-wgWhitelistAccount-sysop' => 'Správci mohou vytvářet účty pro ostatní',
'sitesettings-wgWhitelistAccount-developer' => 'Vývojáři mohou vytvářet účty pro uživatele',
'sitesettings-wgSysopUserBans' => 'Správci mohou zablokovat přihlášené uživatele',
'sitesettings-wgSysopRangeBans' => 'Správci mohou zablokovat rozsah IP adres',
'sitesettings-wgDefaultBlockExpiry' => 'Implicitně vyprší blokování za:',
'sitesettings-wgMiserMode' => 'Zapnout ubohý režim, při kterém je většina „nákladných“ schopností zakázána',
'sitesettings-wgDisableQueryPages' => 'V ubohém režimu zakázat všechny dotazovací stránky, nejen ty „nákladné“',
'sitesettings-wgUseWatchlistCache' => 'Vytvářet seznam sledovaných stránek zhruba každou hodinu',
'sitesettings-wgWLCacheTimeout' => 'Délka „zhruba hodiny“ zmíněné výše (v sekundách):',
'sitesettings-cookies' => 'Cookies',
'sitesettings-performance' => 'Výkon',
'sitesettings-images' => 'Obrázky',

'passwordtooshort' => 'Vaše heslo je příliš krátké. Musí obsahovat nejméně $1 znaků.', #TODO: plural

# external editor support
'edit-externally' => 'Editovat tento soubor v externím programu',
'edit-externally-help' => 'Více informací najdete v [http://meta.wikimedia.org/wiki/Help:External_editors nápovědě pro nastavení].',

# 'all' in various places, this might be different for inflicted languages
'all' => 'všechny',
'recentchangesall' => 'všechny',
'imagelistall' => 'všechny',
'watchlistall1' => 'všechny',
'watchlistall2' => 'všechny',
'contributionsall' => 'všechny'
);

#--------------------------------------------------------------------------
# Internationalisation code
#--------------------------------------------------------------------------

class LanguageCs extends LanguageUtf8 {

        function getBookstoreList () {
                global $wgBookstoreListCs ;
                return $wgBookstoreListCs ;
        }

        function getNamespaces() {
                global $wgNamespaceNamesCs;
                return $wgNamespaceNamesCs;
        }

        function getNsText( $index ) {
                global $wgNamespaceNamesCs;
                return $wgNamespaceNamesCs[$index];
        }

        function getNsIndex( $text ) {
                global $wgNamespaceNamesCs;

                foreach ( $wgNamespaceNamesCs as $i => $n ) {
                        if ( 0 == strcasecmp( $n, $text ) ) { return $i; }
                }
                return false;
        }

        function getQuickbarSettings() {
                global $wgQuickbarSettingsCs;
                return $wgQuickbarSettingsCs;
        }

        function getSkinNames() {
                global $wgSkinNamesCs;
                return $wgSkinNamesCs;
        }

        function getValidationTypes() {
            global $wgValidationTypesCs;
            return $wgValidationTypesCs;
        }
/*
        function &getMagicWords()
        {
            global $wgMagicWordsCs;
            return $wgMagicWordsCs;
        }
*/

        # Datové a časové funkce možno upřesnit podle jazyka
        # TODO: Umožnit nastavování formátu data a času.
        function date( $ts, $adj = false )
        {
                if ( $adj ) { $ts = $this->userAdjust( $ts ); }

                $d = (0 + substr( $ts, 6, 2 )) . '. ' .
                $this->getMonthAbbreviation( substr( $ts, 4, 2 ) ) .
                  ' ' . 
                  substr( $ts, 0, 4 );
                return $d;
        }

        function getValidSpecialPages()
        {
                global $wgValidSpecialPagesCs;
                return $wgValidSpecialPagesCs;
        }

        function getSysopSpecialPages()
        {
                global $wgSysopSpecialPagesCs;
                return $wgSysopSpecialPagesCs;
        }

        function getDeveloperSpecialPages()
        {
                global $wgDeveloperSpecialPagesCs;
                return $wgDeveloperSpecialPagesCs;
        }

        function getMessage( $key )
        {
                global $wgAllMessagesCs;
                if(array_key_exists($key, $wgAllMessagesCs))
                        return $wgAllMessagesCs[$key];
                else
                        return parent::getMessage($key);
        }

        function getAllMessages()
        {
                global $wgAllMessagesCs;
                return $wgAllMessagesCs;
        }

        function checkTitleEncoding( $s ) {
                global $wgInputEncoding;

                # Check for non-UTF-8 URLs; assume they are WinLatin2
                $ishigh = preg_match( '/[\x80-\xff]/', $s);
                $isutf = ($ishigh ? preg_match( '/^([\x00-\x7f]|[\xc0-\xdf][\x80-\xbf]|' .
                '[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xf7][\x80-\xbf]{3})+$/', $s ) : true );

                if( $ishigh and !$isutf ) {
                        return iconv( 'cp1250', 'utf-8', $s );
				}

                return $s;
        }

	function formatNum( $number ) {
		global $wgTranslateNumerals;
		return $wgTranslateNumerals ? strtr($number, '.,', ', ' ) : $number;	#TODO: nbsp instead of space
	}

        # Grammatical transformations, needed for inflected languages
        # Invoked by putting {{grammar:case|word}} in a message
		function convertGrammar( $word, $case ) {
			# allowed values for $case:
			#	1sg, 2sg, ..., 7sg -- nominative, genitive, ... (in singular)
			switch ( $word ) {
				case 'Wikipedia':
				case 'Wikipedie':
					switch ( $case ) {
						case '3sg':
						case '4sg':
						case '6sg':
							return 'Wikipedii';
						case '7sg':
							return 'Wikipedií';
						default:
							return 'Wikipedie';
					}

				case 'Wiktionary':
				case 'Wikcionář':
					switch ( $case ) {
						case '2sg':
							return 'Wikcionáře';
						case '3sg':
						case '5sg';
						case '6sg';
							return 'Wikcionáři';
						case '7sg':
							return 'Wikcionářem';
						default:
							return 'Wikcionář';
					}

				case 'Wikiquote':
				case 'Wikicitáty':
					switch ( $case ) {
						case '2sg':
							return 'Wikicitátů';
						case '3sg':
							return 'Wikicitátům';
						case '6sg';
							return 'Wikicitátech';
						default:
							return 'Wikicitáty';
					}
			}
			# unknown
			return $word;
		}
}

?>
