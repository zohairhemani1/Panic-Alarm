<?php
	
	echo "initialized";
	
	include 'connect_to_mysql.php';
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$friendNumber = $_POST['parameterOne'];
	$myNumber = $_POST['username'];
	$activate = 0;
	
	$query = "INSERT INTO friends(mynumber,friendsnumber,activate) VALUES ('$myNumber','$friendNumber','$activate')";
	mysqli_query($con,$query);
	mysqli_close($con);

?>