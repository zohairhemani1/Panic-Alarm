<?php
	
	include 'connect_to_mysql.php';
	
	$returnArray = array();
	
	$friendsNumber = $_POST['parameterTwo'];
	$myNumber = $_POST['parameterOne'];
	
	$query = "DELETE from friends where (mynumber = '$myNumber' and friendsnumber = '$friendsNumber') OR (mynumber = '$friendsNumber' and friendsnumber = '$myNumber')";
	mysqli_query($con,$query);
	mysqli_close($con);
	
	$returnArray['success'] = "200";
	echo json_encode($returnArray);
	
?>