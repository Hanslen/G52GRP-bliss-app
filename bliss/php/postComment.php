<?php

require("Conn.php");
require("MySQLDao.php");
$comment = htmlentities($_POST["comment"]);
$owner = htmlentities($_POST["owner"]);
$topicId = htmlentities($_POST["topicId"]);
$time = date("Y-m-d H:i:s"); 
// $timeNow = "2016-2-13 23:05:22";

$returnValue = array();


$dao = new MySQLDao();
$dao->openConnection();
$postResult = $dao->postNewComment($comment,$owner,$time,$topicId);

$returnValue["postResult"] = $postResult;
$returnValue["status"] = "Success";
$returnValue["message"] = "Post successfully:-)";
echo json_encode($returnValue);

$dao->closeConnection();

?>