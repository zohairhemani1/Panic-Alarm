<?php
	include 'connect_to_mysql.php';
	$storedNumber = $_POST['username'];
	//$storedNumber = "03152151511";
	
	$PanicFromArray = array();
	
	$query = "SELECT * from `panic_victim` p , `panic_friends` f, `registeration` r WHERE f.friendsnumber = '$storedNumber' AND f.panicvictim_id = p.id AND r.password = p.mynumber;";
	$result = mysqli_query($con,$query);
	
	while($row = mysqli_fetch_assoc($result))
	{
		$PanicFromArray[] = $row;
	}
	
	echo json_encode($PanicFromArray);
	
?>