<?php

	$favouritesArray = array();
	
	$con=mysqli_connect("localhost","iospanic","Hemani786!","iospanic");
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$myNumber = $_POST['parameterOne'];
	
	$query = "SELECT DISTINCT f.mynumber, f.friendsnumber, f.activate, r.username
				FROM friends f, registeration r
				WHERE f.friendsnumber = r.password
				AND f.mynumber LIKE  '$myNumber'
				AND f.activate LIKE  '1' OR f.mynumber = r.password
				AND f.friendsnumber LIKE  '$myNumber'
				AND f.activate LIKE  '1'";
	$result = mysqli_query($con,$query);
	
	while($row = mysqli_fetch_array($result))
	{
		array_push($favouritesArray,$row);
	}
	
	echo json_encode($favouritesArray);


?>