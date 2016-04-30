<?php

require("Conn.php");
require("MySQLDao.php");

$returnValue = array();
$topicId = htmlentities($_POST["topicId"]);

$dao = new MySQLDao();
$dao->openConnection();
$getResult = $dao->getFavouriteOneTopic($topicId);

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