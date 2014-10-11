<?php
	
	
	include 'connect_to_mysql.php';
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
		
		$myNumber = $_POST['parameterOne'];
		$numberToAccept = $_POST['parameterTwo'];
		
		
		$query = "UPDATE friends SET activate = '1' WHERE friendsnumber = '$myNumber' AND mynumber = '$numberToAccept'";
		mysqli_query($con,$query);
?>