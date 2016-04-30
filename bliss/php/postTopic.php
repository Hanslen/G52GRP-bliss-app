<?php

require("Conn.php");
require("MySQLDao.php");
$title = htmlentities($_POST["title"]);
$topicIntro = htmlentities($_POST["topicIntro"]);
$owner = htmlentities($_POST["email"]);
$time = date("Y-m-d H:i:s"); 
// $timeNow = "2016-2-13 23:05:22";

$returnValue = array();


$dao = new MySQLDao();
$dao->openConnection();
$postResult = $dao->postNewTopic($title,$topicIntro,$owner,$time);

$returnValue["postResult"] = $postResult;
$returnValue["status"] = "Success";
$returnValue["message"] = "Post successfully:-)";
echo json_encode($returnValue);

$dao->closeConnection();

?>