<?php
 
// Create connection
$con=mysqli_connect("localhost","iospanic","Hemani786!","iospanic");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$username = $_POST['username'];
$password = $_POST['password'];

// This SQL statement selects ALL from the table 'Locations'
$query = "SELECT * FROM registeration WHERE username like '$username' AND password like '$password'";
$result = mysqli_query($con,$query);
$count = mysqli_num_rows($result);
$row = $result->fetch_object();
$resultArray = array();
$tempArray = array();

if($count == 1)
{
	$tempArray = $row;
    array_push($resultArray, $tempArray);
	echo json_encode($resultArray);
}
else
{
	$query = "INSERT INTO registeration(username,password) VALUES('$username','$password')";
	$result = mysqli_query($con,$query);
}
// Close connections
mysqli_close($con);

?>