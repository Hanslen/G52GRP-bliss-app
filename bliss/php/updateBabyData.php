<?php

require("Conn.php");
require("MySQLDao.php");
$email = htmlentities($_POST["email"]);
$month = htmlentities($_POST["month"]);
$weight = htmlentities($_POST["weight"]);

$returnValue = array();

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->updateBabyData($email,$month, $weight);

if(!empty($userDetails))
{
	$returnValue["status"] = "Pass";
	$returnValue["message"] = "Update baby data successfully!:-)";
	echo json_encode($returnValue);

} else {

	$returnValue["status"] = "error";
	$returnValue["message"] = "Please check your network configuration! The data is only store locally.:-(";
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>