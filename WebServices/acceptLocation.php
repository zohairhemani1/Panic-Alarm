<?php
	
	include 'connect_to_mysql.php';
	$id = $_POST['parameterOne'];
	$panic_id = $_POST['parameterTwo'];
	$friendsNumber = $_POST['parameterThree'];
	$storedNumber = $_POST['username'];
	$returnArray = array();
	
	$query = "UPDATE panic_friends SET received = '1' WHERE id = '156' AND panicvictim_id = '132' AND friendsnumber = '090078601'";
	$result = mysqli_query($con,$query);
	
	if($result){
		$returnArray['success'] = '200';
	}else{
		$returnArray['error'] = 'Cannot get user\'s location';
	}
	
	
	echo json_encode($returnArray);
	
?>