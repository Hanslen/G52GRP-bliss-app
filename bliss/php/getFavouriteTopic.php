<?php

require("Conn.php");
require("MySQLDao.php");

$returnValue = array();
//remeber to back to post
$email = htmlentities($_POST["email"]);

$dao = new MySQLDao();
$dao->openConnection();
$getResult = $dao->getFavouriteTopic($email);
// print_r($getResult);
$topicId = "(";
for ($i=0; $i < sizeof($getResult); $i++) { 
	# code...
	$topicId = $topicId.$getResult[$i]["topicId"];
	if($i != sizeof($getResult)-1){
		$topicId = $topicId.",";
	}
}

$topicId = $topicId.")";
$getResult = $dao->getFavouriteOneTopic($topicId);
// print_r($getResult);


// $getResult = $dao->getFavouriteOneTopic($getResult)
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