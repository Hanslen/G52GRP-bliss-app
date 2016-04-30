<?php

require("Conn.php");
require("MySQLDao.php");
$email = htmlentities($_POST["email"]);
$username = htmlentities($_POST["username"]);

$returnValue = array();

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->updateUsername($email,$username);

if(!empty($userDetails))
{
	$returnValue["status"] = "Pass";
	$returnValue["message"] = $result;
	echo json_encode($returnValue);

} else {

	$returnValue["status"] = "error";
	$returnValue["message"] = "Please check your network configuration!:-(";
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>