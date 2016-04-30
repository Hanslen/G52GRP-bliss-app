<?php
class MySQLDao {
var $dbhost = null;
var $dbuser = null;
var $dbpass = null;
var $conn = null;
var $dbname = null;
var $result = null;

function __construct() {
$this->dbhost = Conn::$dbhost;
$this->dbuser = Conn::$dbuser;
$this->dbpass = Conn::$dbpass;
$this->dbname = Conn::$dbname;
}

public function openConnection() {
$this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);
if (mysqli_connect_errno())
echo new Exception("Could not establish connection with database");
}

public function getConnection() {
return $this->conn;
}

public function closeConnection() {
if ($this->conn != null)
$this->conn->close();
}

public function getUserDetails($email)
{
$returnValue = array();
$sql = "select * from users where email='" . $email . "'";

$result = $this->conn->query($sql);
if ($result != null && (mysqli_num_rows($result) >= 1)) {
$row = $result->fetch_array(MYSQLI_ASSOC);
if (!empty($row)) {
$returnValue = $row;
}
}
return $returnValue;
}

public function getUserDetailsWithPassword($email, $userPassword)
{
$returnValue = array();
$sql = "select * from users where email='" . $email . "' and password='" .$userPassword . "'";

$result = $this->conn->query($sql);
if ($result != null && (mysqli_num_rows($result) >= 1)) {
$row = $result->fetch_array(MYSQLI_ASSOC);
if (!empty($row)) {
$returnValue = $row;
}
}
return $returnValue;
}

public function registerUser($email, $password, $faceBookId, $username, $userImage)
{
// $sql = "insert into users set email= '" . $email . "' password='" .$password . "'";
$sql = "insert into users set email=?, password=?, faceBookId=?, username=?, userImage=?";
$statement = $this->conn->prepare($sql);

if (!$statement)
throw new Exception($statement->error);

$statement->bind_param("sssss", $email, $password, $faceBookId, $username,$userImage);
$returnValue = $statement->execute();
$result = $this->conn->query($sql);

//Create a row in the babyData
$sql = "insert into babyData set email=?";
$statement = $this->conn->prepare($sql);

if (!$statement)
throw new Exception($statement->error);

$statement->bind_param("s", $email);
$returnValue = $statement->execute();
$result = $this->conn->query($sql);

return $returnValue;
}

public function resetPassword($email, $password){
	$sql = "update users set password = '" . $password . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}
public function updateUserIcon($email){
	$icon = "http://hanslen.me/php/userIcon/".$email.".jpg";
	$sql = "update users set userImage = '" . $icon . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}
public function updateUsername($email, $username){
	$sql = "update users set username = '" . $username . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}
public function updateBabyName($email, $value){
	$sql = "update users set babyname = '" . $value . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}
public function updateBabyData($email, $month, $weight){
	$sql = "update babyData set `".$month."` = '" . $weight . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}

public function initializeBaby($name,$birthday, $length, $weight, $email, $gender){
	$sql = "update users set babyname='" . $name . "',babyweight='".$weight."',birthday='".$birthday."',gender='".$gender."',length='".$length."'  where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;

	// $sql = "update users set babyname=?,birthday=?, length=?,weight=?, gender=? where email=?";
	// $statement = $this->conn->prepare($sql);

	// if (!$statement)
	// 	throw new Exception($statement->error);

	// $statement->bind_param("ssssss", $name, $birthday, $length, $weight,$gender, $email);
	// $returnValue = $statement->execute();
	// $result = $this->conn->query($sql);
	// return $returnValue;
}

public function updateBabyLength($email, $value){
	$sql = "update users set length = '" . $value . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}
public function updateBabyWeight($email, $value){
	$sql = "update users set babyweight = '" . $value . "' where email='" .$email . "'";
	$result = $this->conn->query($sql);
	return $result;
}

public function postNewTopic($title,$topicIntro,$owner,$time){
	$sql = "insert into topic set title=?, introduction=?, time=?, follows=0, owner=?";
	$statement = $this->conn->prepare($sql);

	if (!$statement)
		throw new Exception($statement->error);

	$statement->bind_param("ssss", $title, $topicIntro, $time,$owner);
	$returnValue = $statement->execute();
	$result = $this->conn->query($sql);
	return $returnValue;
}

public function getAllTopic(){
	$returnValue = array();
	$sql = "select * from users, topic where users.email = topic.owner;";

	$result = $this->conn->query($sql);
	if ($result != null) {
		$row = $result->fetch_all(MYSQLI_ASSOC);
        if (!empty($row)) {
			$returnValue = $row;
		}
	}
	return $returnValue;
}
public function postNewComment($comment,$owner,$time, $topicId){
	$sql = "insert into comment set owner=?, comment=?, time=?, like_num=0, topicId=?";
	$statement = $this->conn->prepare($sql);

	if (!$statement)
		throw new Exception($statement->error);

	$statement->bind_param("ssss", $owner, $comment, $time, $topicId);
	$returnValue = $statement->execute();
	$result = $this->conn->query($sql);
	return $returnValue;
}
public function getAllComment($topicId){
	$returnValue = array();
	$sql = "select * from comment,users where comment.owner=users.email AND topicId='" . $topicId . "'";

	$result = $this->conn->query($sql);
	if ($result != null) {
		$row = $result->fetch_all(MYSQLI_ASSOC);
        if (!empty($row)) {
			$returnValue = $row;
		}
	}
	return $returnValue;
}

public function getBabyChartData($email){
	$returnValue = array();
	$sql = "select * from babyData where email='" . $email . "'";

	$result = $this->conn->query($sql);
	if ($result != null && (mysqli_num_rows($result) >= 1)) {
	$row = $result->fetch_array(MYSQLI_ASSOC);
	if (!empty($row)) {
	$returnValue = $row;
	}
	}
	return $returnValue;
}

public function favouriteTopic($email, $topicId){
	$sql = "insert into favouriteTopic set email=?, topicId=?";
	$statement = $this->conn->prepare($sql);

	if (!$statement)
		throw new Exception($statement->error);

	$statement->bind_param("ss", $email, $topicId);
	$returnValue = $statement->execute();
	$result = $this->conn->query($sql);
	return $returnValue;
}
public function getFavouriteTopic($email){
	$returnValue = array();
	$sql = "select topicId from favouriteTopic where email='" . $email . "'";

	$result = $this->conn->query($sql);
	if ($result != null) {
		$row = $result->fetch_all(MYSQLI_ASSOC);
        if (!empty($row)) {
			$returnValue = $row;
		}
	}
	return $returnValue;
}
public function getFavouriteOneTopic($topicId){
	$returnValue = array();
	$sql = "select * from topic where id in " . $topicId;
	// echo $sql;
	$result = $this->conn->query($sql);
	if ($result != null) {
		$row = $result->fetch_all(MYSQLI_ASSOC);
        if (!empty($row)) {
			$returnValue = $row;
		}
	}
	return $returnValue;
}
public function deleteFavouriteTopic($email, $topicId){
	$sql = "delete from favouriteTopic where email=? AND topicId=?";
	$statement = $this->conn->prepare($sql);

	if (!$statement)
		throw new Exception($statement->error);

	$statement->bind_param("ss", $email, $topicId);
	$returnValue = $statement->execute();
	$result = $this->conn->query($sql);
	return $returnValue; 
}
}
?>