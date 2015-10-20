<?php
	
	
	include 'connect_to_mysql.php';
	$returnArray = array();
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
		
		$myNumber = $_POST['parameterOne'];
		$numberToAccept = $_POST['parameterTwo'];
		
		
		$query = "UPDATE friends SET activate = '1' WHERE friendsnumber = '$myNumber' AND mynumber = '$numberToAccept'";
		$result = mysqli_query($con,$query);
		
		if(mysqli_affected_rows($con) == 1)
		{
			$returnArray['status'] = 1;
		}
		else
		{
			$returnArray['status'] = -1;
		}
		
		echo json_encode($returnArray);
		
?>