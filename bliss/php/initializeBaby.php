<?php

require("Conn.php");
require("MySQLDao.php");
$email = htmlentities($_POST["email"]);
$name = htmlentities($_POST["name"]);
$birthday = htmlentities($_POST["birthday"]);
$length = htmlentities($_POST["length"]);
$weight = htmlentities($_POST["weight"]);
$gender = htmlentities($_POST["gender"]);

$returnValue = array();

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->initializeBaby($name,$birthday,$length,$weight,$email,$gender);

if(!empty($userDetails))
{
	$returnValue["status"] = "Pass";
	$returnValue["message"] = $userDetails;
	echo json_encode($returnValue);

} else {

	$returnValue["status"] = "error";
	$returnValue["message"] = $userDetails;
	echo json_encode($returnValue);
}


$dao->closeConnection();

?>