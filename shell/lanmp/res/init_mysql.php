<?php
$link = mysql_connect('localhost', 'root', '');
if ($link) {
	$password = randstr(10);
    mysql_select_db('mysql');
    mysql_query("SET character_set_connection=gbk,character_set_results=gbk,character_set_client=binary", $link);
    mysql_query("SET sql_mode=''", $link);
    mysql_query("set password for 'root'@'localhost' = PASSWORD('{$password}')");
    mysql_query("delete from user where user = '' or password = ''");
    mysql_query("flush privileges");
}


file_put_contents('account.log', str_replace('mysql_password', $password, file_get_contents('account.log')));

function randstr($length) {
	return substr(md5(num_rand($length)), mt_rand(0, 32 - $length), $length);
}
function num_rand($length) {
	mt_srand((double) microtime() * 1000000);
	$randVal = mt_rand(1, 9);
	for ($i = 1; $i < $length; $i++) {
		$randVal .= mt_rand(0, 9);
	}
	return $randVal;
}
