<?php
	
	include 'connect_to_mysql.php';
	$jsonArray = json_decode(stripslashes($_POST['parameterOne']), true);
	
	$number = "";
	$name = "";
	$latitude = "";
	$longitude = "";
	
	if (is_array($jsonArray))
	{
			$jsonArray = $jsonArray[0];
			$name = $jsonArray['name'];
			$number = $jsonArray['password'];
			$longitude = $jsonArray['longitude'];
			$latitude = $jsonArray['latitude'];
			$panicMessage = $jsonArray['panicMessage'];
			$type = $jsonArray['type'];
	}
	
	/* Getting Favourites  */
	
	$query_favourites = "SELECT f.mynumber, f.friendsnumber, f.activate, r.username, r.pic
							FROM friends f, registeration r
							WHERE f.friendsnumber = r.password
							AND f.mynumber LIKE  '$number'
							AND f.activate LIKE  '1' OR f.mynumber = r.password
							AND f.friendsnumber LIKE  '$number'
							AND f.activate LIKE  '1'";
				
	$result_favourites = mysqli_query($con,$query_favourites);
	$count = mysqli_num_rows($result_favourites);
	
	if($count>0)	
	{
		/* Insertion of Panic  Victim's Information */	
		$query = "INSERT INTO panic_victim(mynumber,timestamp,latitude,longitude,type,panicMessage) 
							  VALUES('$number',sysdate(),'$latitude','$longitude','$type','$panicMessage')";
		mysqli_query($con,$query);
		
		/* Getting MAX ID i.e Last Panic Victim's Information. */
		$query_get_last_id = "SELECT MAX(id) from panic_victim";
		$result = mysqli_query($con,$query_get_last_id);
		$row = mysqli_fetch_array($result);
		$foreignKey = $row['MAX(id)'];
	
	
		while($row = mysqli_fetch_array($result_favourites))
		{
			$db_mynumber = $row['mynumber'];
			$db_friendsnumber = $row['friendsnumber'];
			
			if($db_mynumber != $number)
				$friendsnumber = $db_mynumber;
			else if ($db_friendsnumber != $number)
				$friendsnumber = $db_friendsnumber;
			else
				echo "No Number.";
			
			$query_panic_friends = "INSERT INTO panic_friends(panicvictim_id,friendsnumber) VALUES('$foreignKey','$friendsnumber')";
			mysqli_query($con,$query_panic_friends);
		}
		echo "Your Panic has been Sent";
	}
	
	else
		echo "You don't have any friends yet.";
	
	mysqli_close($con);
	
?>