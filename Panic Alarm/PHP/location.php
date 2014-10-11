<?php
	
	$con=mysqli_connect("localhost","iospanic","Hemani786!","iospanic");
 
	// Check connection
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$latitude = $_POST['parameterOne'];
	$longitude = $_POST['parameterTwo'];
	$username = $_POST['username'];
	
	$query = "INSERT INTO geolocation(latitude,longitude,username) VALUES('$latitude','$longitude','$username')";
	mysqli_query($con,$query);
	
	echo "Location Inserted: Latitude: {$latitude} Longitude: {$longitude} Username: {$username}";

?>