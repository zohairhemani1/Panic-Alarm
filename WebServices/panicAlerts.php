<?php
	
	$panicAlerts = array();
	
	include 'connect_to_mysql.php';
	
	/* User's Number */
	$storedNumber = "03432637576"; 
	
	/* Fetch all panic alerts sent to a particular user Either Received or Not. */
	$query = "SELECT * FROM panic_friends, panic_victims WHERE panic_friends.friendsnumber like '$storedNumber' 
			  		   AND panic_friends.panicid = panic_victims.id";
	$result = mysqli_query($con,$query);
	
	while($row = mysqli_fetch_assoc($result))
	{
		$victim_username = $row['username'];
		$victim_latitude = $row['latitude'];
		$victim_longitude = $row['longitude'];
		$timestamp_panicsent = $row['timestamp'];
		$friendsnumber = $row['friendsnumber'];
		
		array_push($panicAlerts,$row);
	}
	
	echo json_encode($panicAlerts);
	
?>