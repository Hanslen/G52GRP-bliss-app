<?php

require("Conn.php");
require("MySQLDao.php");

$returnValue = array();
//remeber to back to post
$email = htmlentities($_POST["email"]);
$topicId = htmlentities($_POST["topicId"]);

$dao = new MySQLDao();
$dao->openConnection();
$getResult = $dao->deleteFavouriteTopic($email, $topicId);


// $getResult = $dao->getFavouriteOneTopic($getResult)
if($getResult){
	$returnValue["getResult"] = $getResult;
	$returnValue["status"] = "Success";
	$returnValue["message"] = "Delete successfully:-)";
	echo json_encode($returnValue);
}else{
	$returnValue["getResult"] = $getResult;
	$returnValue["status"] = "Error";
	$returnValue["message"] = "Please check your network configuration!:-(";
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>