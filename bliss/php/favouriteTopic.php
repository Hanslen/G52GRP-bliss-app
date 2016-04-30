<?php 


require("Conn.php");
require("MySQLDao.php");

$email = htmlentities($_POST["email"]);
$topicId = htmlentities($_POST["topicId"]);

$returnValue = array();

$dao = new MySQLDao();
$dao->openConnection();
$favouriteResult = $dao->favouriteTopic($email, $topicId);

$returnValue["status"] = "Success";
$returnValue["message"] = $favouriteResult;
echo json_encode($returnValue);
return;


$dao->closeConnection();

?>