<?php
	include 'connect_to_mysql.php';
	$storedNumber = $_POST['username'];
	$panicMessage = $_POST['parameterOne'];
	$username = $_POST['parameterTwo'];
	$returnArray = array();
	
	$query = "UPDATE registeration SET panicMessage = '$panicMessage', username = '$username' WHERE password = '$storedNumber' ";
	mysqli_query($con,$query) or die('Couldnot Update Panic Message. Error Occured');
	
	$returnArray['success'] = "OK";
	
	echo json_encode($returnArray);
	
	
	
?>