<?php
	
	include 'connect_to_mysql.php';
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$number = $_POST['parameterOne'];
	$username = $_POST['username'];
	
	$query = "SELECT * from registeration WHERE password like '$number'";
	$result = mysqli_query($con,$query);
	$count = mysqli_num_rows($result);
	//$row = mysqli_fetch_array($result);
	//$name = $row['username'];
	if($count == 1)
	{
		echo "1";
	}
	else
	{
		echo "0";
	}
	
?>