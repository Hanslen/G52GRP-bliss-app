<?php

require("Conn.php");
require("MySQLDao.php");
$topicId = htmlentities($_POST["topicId"]);

$returnValue = array();

$dao = new MySQLDao();
$dao->openConnection();
$getResult = $dao->getAllComment($topicId);

if($getResult){
	$returnValue["getResult"] = $getResult;
	$returnValue["status"] = "Success";
	$returnValue["message"] = "Get successfully:-)";
	echo json_encode($returnValue);
}else{
	$returnValue["getResult"] = $getResult;
	$returnValue["status"] = "Error";
	$returnValue["message"] = "Please check your network configuration!:-(";
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>