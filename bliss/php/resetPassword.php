<?php

require("Conn.php");
require("MySQLDao.php");
$email = htmlentities($_POST["email"]);
$oldpassword = htmlentities($_POST["oldpassword"]);
$newpassword = htmlentities($_POST["newpassword"]);
$returnValue = array();

$secure_password = md5($oldpassword);

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetailsWithPassword($email,$secure_password);

if(!empty($userDetails))
{
	$returnValue["status"] = "Pass";
	echo json_encode($returnValue);
	$secure_passwordnew = md5($newpassword);
	$result = $dao->resetPassword($email, $secure_passwordnew);
	$returnValue["message"] = $result;

} else {

	$returnValue["status"] = "error";
	$returnValue["message"] = "User and password do not match.";
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>