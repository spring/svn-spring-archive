<?php
/**
 * PHP Includes via Syntax
 *
 * Please create the directory "phpincludes" in your installation of
 * DokuWiki. Now you can put there any HTML or PHP File you want to
 * this directory.
 *
 * <phpinc=filename>
 * 
 * The syntax includes the PHP file per include an puts the result into
 * the wiki page.
 *
 * @license    GNU_GPL_v2
 * @author     Markus Frosch <markus [at] lazyfrosch [dot] de>
 */
 
if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');
 
 
class syntax_plugin_phpinc extends DokuWiki_Syntax_Plugin {
 
    function getInfo(){
        return array(
            'author' => 'Markus Frosch',
            'email'  => 'markus@lazyfrosch.de',
            'date'   => '2006-05-11',
            'name'   => 'PHP Include',
            'desc'   => 'Allows you to make an include of an PHP File on Server',
            'url'    => 'http://wiki.splitbrain.org/plugin:phpinc',
        );
    }
 
 
    function getType(){ return 'container'; }
    function getPType(){ return 'normal'; }
    function getAllowedTypes() { 
        return array('substition','protected','disabled');
    }
    function getSort(){ return 195; }
 
    function connectTo($mode) {
        $this->Lexer->addSpecialPattern('<phpinc=.*?>',$mode,'plugin_phpinc');
    }
    function handle($match, $state, $pos, &$handler){
 
        switch ($state) {
          case DOKU_LEXER_SPECIAL :
            return array($state, $match);          
 
          default:
            return array($state);
        }
    }
 
    function render($mode, &$renderer, $indata) {
        if($mode == 'xhtml'){
          list($state, $data) = $indata;
 
          switch ($state) {
            case DOKU_LEXER_SPECIAL :
              preg_match("#^<phpinc=(.+)>$#", $data, $matches);
              $file = $matches[1];
              if(preg_match("#^[a-z0-9\-_ \./]+$#i", $file) and strstr("..", $file) == false and file_exists(DOKU_INC."phpincludes/".$file)) {
                    $renderer->info['cache'] = FALSE;
                    ob_start();
                    include(DOKU_INC."phpincludes/".$file);
                    $content = ob_get_contents();
                    ob_end_clean();
                    $renderer->doc .= $content;
              }
              else
                    $renderer->doc .= $renderer->_xmlEntities($data);
              break;
  
          }
          return true;
        }
        
        // unsupported $mode
        return false;
    } 
}
 
?>
