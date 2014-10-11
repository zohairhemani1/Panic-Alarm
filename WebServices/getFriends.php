<?php

$friendsArray = array();

$con=mysqli_connect("localhost","iospanic","Hemani786!","iospanic");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 


$username = $_POST['parameterOne'];
$password = $_POST['parameterTwo'];
$number = $_POST['username'];


$query = "SELECT DISTINCT mynumber, friendsnumber, activate
			FROM friends
			WHERE activate =0
			AND (mynumber =  '$number' || friendsnumber =  '$number')
			";
$result = mysqli_query($con,$query);


while($row = mysqli_fetch_array($result))
{
	array_push($friendsArray,$row);
}

	echo json_encode($friendsArray);

	
	
?>