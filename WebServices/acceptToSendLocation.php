<?php
	
	include 'connect_to_mysql.php';
	$returnArray = array();
	$phoneNumer = $_POST['username'];
	$friendsNumber = $_POST['parameterOne'];
	//$locationArray = $_POST['parameterTwo'];
	$locationArray = array (20,30);
	$panicvictim_ID = $_POST['parameterThree'];
	
	//echo "FriendsNumber: " . $friendsNumber;
	//echo "Latitude: " . $latitude;
	//echo "Longitude: " . $longitude;
	
	$query = "UPDATE `panic_victim` pv, `panic_friends` pf 
				SET pv.latitude = '$locationArray[0]', pv.longitude = '$locationArray[1]', pf.received = '1' WHERE  (pv.id = pf.panicvictim_id 	AND pv.mynumber = '$phoneNumer' AND pf.friendsnumber = '$friendsNumber' AND pv.id = '$panicvictim_ID')";
	$result = mysqli_query($con,$query);
	
	//echo "Result Variable: " . $result;
	
	if($result){
		$returnArray['success'] = "200";
	}
	else{
		$returnArray['error'] = "Cannot send your location. Please try again later.";
	}
	
	
	mysqli_close($con);
	
	
	echo json_encode($returnArray);
	
?>