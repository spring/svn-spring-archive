<?
if (!@mysql_connect("localhost", "iamacup_stats", "239i9d2")) exit("FAILED 0");
if (!@mysql_select_db("iamacup_stats")) exit("FAILED 0");


	function updatePlayer($name, $ip, $rank) {
		if ($rank == "") $rank = 0;
		if ($name != "") {
			$res = mysql_query ("SELECT id FROM Players WHERE name='$name'");
			if (mysql_num_rows($res) > 0) {
				$id = mysql_result($res,0,0);
				if ($rank > 0) mysql_query("UPDATE Players SET rank=$rank, lastSeen = ".time()." WHERE id = $id"); 
				else mysql_query("UPDATE Players SET lastSeen = ".time()." WHERE id = $id");
			} else {
				mysql_query("INSERT INTO Players (name, lastSeen, rank) VALUES ('$name', ".time().", $rank)");
				$id = mysql_insert_id();
			}
			if ($ip!="" && $ip != "255.255.255.255") {
				if ($ip == -1) $ip = ip2long($_SERVER['REMOTE_ADDR']); else $ip = ip2long($ip);
				mysql_query("REPLACE INTO Players2ip (playerId, ip) VALUES ($id, $ip)");
			}
			return $id;		
		} else return 0;
	}
	
	
	function validate() {
		$u = $_SERVER['QUERY_STRING'];
		$b = explode("&hash=", $u);
		$res = mysql_query("SELECT password FROM Autohosts AS a JOIN Players AS p ON a.playerId = p.id WHERE p.name = '$_GET[login]'");
		if (mysql_num_rows($res)>0) {
			$db_pas = mysql_result($res,0,0);
			if ($_GET[hash] == md5(urldecode($b[0]).$db_pas)) return 1;
		} else return 0;
		return 0;
	}
	
function makeFilter($nam, $param) {
	$pole = explode(" ", $param);
	$res = "";
	for ($i = 0; $i < count($pole); $i++) {
		if ($i != 0) $res .= " AND";
		$res.= " $nam LIKE '%".$pole[$i]."%'";
	}
	return $res;
}

function filterPlayers($p) {
	$res = mysql_query ("SELECT id FROM Players WHERE name='$p'");
	if (mysql_num_rows($res) > 0) {
		$id = mysql_result($res,0,0);
		$ret[] = $id;
		return $ret;
	}
	$res = mysql_query ("SELECT id FROM Players WHERE ".makeFilter("name", $p));
	if (mysql_num_rows($res) >0) {
		while (($row=mysql_fetch_row($res))) {
			$ret[] = $row[0];
		}
	} 
	return $ret;
}


function glue($ar, $start) {
	$ret = "";
	for ($i =$start; $i<count($ar); ++$i) {
		$ret.= $ar[$i];
	}
	return $ret;
}


function timeDiff($t) 
{
	$t = floor($t / 60);
	$v = $t % 60;
	$ret = $v."m";
	$t = floor($t/60);
	$v = $t % 24;
	if ($v >0) $ret = $v."h ".$ret;
    $t = floor($t/24);
    if ($t > 0) $ret = $t."d ".$ret;
    return $ret;
}

function getPlayerName($playerId)
  {
  $q = "SELECT name FROM Players WHERE `id`=$playerId";
  if (!$r = mysql_query($q)) exit (mysql_error() . "<br/>On line " . __LINE__);
  return mysql_result($r,0,0);
  }
function getModName($modId)
  {
  $q = "SELECT name FROM Mods WHERE `id`=$modId";
  if (!$r = mysql_query($q)) exit (mysql_error() . "<br/>On line " . __LINE__);
  return mysql_result($r,0,0);
  }
function getMapName($mapId)
  {
  $q = "SELECT name FROM Maps WHERE `id`=$mapId";
  if (!$r = mysql_query($q)) exit (mysql_error() . "<br/>On line " . __LINE__);
  return mysql_result($r,0,0);
  }

	function getModId($name) {
		$res= mysql_query("SELECT id FROM Mods WHERE name='$name'");
		if (mysql_num_rows($res)>0) {
			return mysql_result($res,0,0);
		} else {
			mysql_query("INSERT INTO Mods (name) VALUES ('$name')");
			return mysql_insert_id();
		}
	}
	
	function getMapId($name) {
		$res= mysql_query("SELECT id FROM Maps WHERE name='$name'");
		if (mysql_num_rows($res)>0) {
			return mysql_result($res,0,0);
		} else {
			mysql_query("INSERT INTO Maps (name) VALUES ('$name')");
			return mysql_insert_id();
		}
	}
	function getPlayerId($name) {
		$res= mysql_query("SELECT id FROM Players WHERE name='$name'");
		if (mysql_num_rows($res)>0) {
			return mysql_result($res,0,0);
		} else {
			return -1;
		}
	}


?>