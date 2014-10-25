<?php
	
	include 'connect_to_mysql.php';
	$returnArray = array();
	$phoneNumer = $_POST['username'];
	$type = $_POST['parameterOne'];
	$friendsNumber = $_POST['parameterTwo'];
	$panicMessage = $_POST['parameterThree'];
	
	$query = "INSERT INTO panic_victim(mynumber,timestamp,type,panicMessage) VALUES('$phoneNumer',now(),'$type','$panicMessage')";
	mysqli_query($con,$query);
	if(mysqli_num_rows ==1){
		$returnArray['success'] = "200";
	}
	else{
		$returnArray['error'] = "Couldn't Find Friends Location. Please try again later.";
	}
	mysqli_close($con);
	
	
	echo json_encode($returnArray);
	
?>