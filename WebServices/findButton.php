<?php
	
	include 'connect_to_mysql.php';
	$returnArray = array();
	$phoneNumer = $_POST['username'];
	$type = $_POST['parameterOne'];
	$friendsNumber = $_POST['parameterTwo'];
	$panicMessage = $_POST['parameterThree'];
	
	$query = "INSERT INTO panic_victim(mynumber,timestamp,type,panicMessage) VALUES('$friendsNumber',now(),'$type','$panicMessage')";
	$result = mysqli_query($con,$query);
	//echo "RESULT: " . $result;
	if($result){
		
		$query = "select max(id) from `panic_victim`";
		$result = mysqli_query($con,$query);
		$row = mysqli_fetch_array($result);
		$max_victimID = $row['max(id)'];
		
		$query = "INSERT INTO panic_friends(panicvictim_id,friendsnumber,received) VALUES ('$max_victimID','$phoneNumer','0')";
		mysqli_query($con,$query);
		
		$returnArray['success'] = "200";
	}
	else{
		$returnArray['error'] = "Couldn't Find Friends Location. Please try again later.";
	}
	mysqli_close($con);
	
	
	echo json_encode($returnArray);
	
?>