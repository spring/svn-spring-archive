<?php

if (!defined('IN_PHPBB'))
{
	die('Hacking attempt');
}

//
// This function returns true if the message includes hyperlinks
//
function as_message_has_links($message)
{
    $pos = stristr($message, "[url");
    if ($pos === false)
        $pos = stristr($message, "http://");
    if ($pos === false)
        $pos = stristr($message, "@");
    if ($pos === false)
        return false;
    return true;
}

//
// This function outputs a debugmessage to a logfile when a message is blocked
//
function as_log_message($message)
{
    global $userdata;

    $fp = fopen('/var/wwwroot/spring/private/spamlog.txt', 'a');
    if (flock($fp, LOCK_EX)) {
        fwrite($fp, '*** Blocked spam post from ' . $userdata['username'] . ' at ' . date('Y-m-d H:i') . "\r\n");
        fwrite($fp, "------------------\r\n");
        fwrite($fp, $message);
        fwrite($fp, "\r\n------------------\r\n\r\n");
        flock($fp, LOCK_UN);
    }

    fclose($fp);
}

//
// This function calls message_die if the message is found to be a spam post
//
function as_check_spam($message)
{
    global $userdata;

    if ($userdata['user_posts'] < 3)
        if (as_message_has_links($message)) {
            as_log_message($message);
            message_die(GENERAL_ERROR, "Your post is denied. To prevent spam, new users are not allowed to post messages that includes hyperlinks or email addresses.");
        }
}

?>