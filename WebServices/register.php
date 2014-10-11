<?php
 
// Create connection
include 'connect_to_mysql.php';
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 


$username = $_POST['username'];
$password = $_POST['password']; 
 
// This SQL statement selects ALL from the table 'Locations'
$query = "INSERT INTO registeration(username,password) VALUES('$username','$password')";
mysqli_query($con,$query); 
// Close connections
mysqli_close($result);
mysqli_close($con);
?>