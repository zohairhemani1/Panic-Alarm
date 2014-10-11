<?php

$friendsArray = array();

include 'connect_to_mysql.php';
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 


$username = $_POST['parameterOne'];
$password = $_POST['parameterTwo'];
$storedNumber = $_POST['username'];


$query = "SELECT friends.mynumber, friends.friendsnumber, friends.activate , registeration.pic,registeration.password,registeration.username
			FROM friends, registeration 
			WHERE friends.activate = 0
			AND (friends.mynumber =  '$storedNumber' || friends.friendsnumber =  '$storedNumber') 
			AND (friends.mynumber = registeration.password || friends.friendsnumber = registeration.password ) group by friends.friendsnumber
			";
$result = mysqli_query($con,$query);


while($row = mysqli_fetch_array($result))
{
	array_push($friendsArray,$row);
}

	echo json_encode($friendsArray);

	
	
?>