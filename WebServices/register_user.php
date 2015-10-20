<?php
 
// Create connection
include 'connect_to_mysql.php';

$username = $_POST['username'];
$password = $_POST['password'];
$pic = $_POST['pic'];

// This SQL statement selects ALL from the table 'Locations'
$query = "SELECT * FROM registeration WHERE password like '$password'";
$result = mysqli_query($con,$query);
$count = mysqli_num_rows($result);
$row = $result->fetch_object();
$resultArray = array();
$tempArray = array();

if($count == 1)
{
	// user already exists against that number
	
	$query = "UPDATE `registeration` SET `username` = '$username', pic = '$pic' where `password` like '$password'  ";
	$result = mysqli_query($con,$query);
	
	$resultArray['status'] = 2;
	
}
else
{
	$query = "INSERT INTO registeration(username,password,pic) VALUES('$username','$password','$pic')";
	$result = mysqli_query($con,$query);
	$resultArray['status'] = 1;
}

echo json_encode($resultArray);
// Close connections
mysqli_close($con);

?>