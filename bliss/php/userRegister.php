<?php 


require("Conn.php");
require("MySQLDao.php");

$email = htmlentities($_POST["email"]);
$password = htmlentities($_POST["password"]);
$faceBookId = htmlentities($_POST["faceBookId"]);
$username = htmlentities($_POST["username"]);
$userImage = htmlentities($_POST["userImage"]);

$returnValue = array();

if(empty($email) || empty($password))
{
$returnValue["status"] = "error";
$returnValue["message"] = "Missing required field";
echo json_encode($returnValue);
return;
}

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetails($email);

if(!empty($userDetails))
{
$returnValue["status"] = "error";
$returnValue["message"] = "This email has been registered.:-(";
echo json_encode($returnValue);
return;
}

$secure_password = md5($password); // I do this, so that user password cannot be read even by me

$result = $dao->registerUser($email,$secure_password, $faceBookId, $username, $userImage);

if($result)
{
$returnValue["status"] = "Success";
$returnValue["message"] = "You have registered successfully.:-)";
echo json_encode($returnValue);
return;
}

$dao->closeConnection();

?>