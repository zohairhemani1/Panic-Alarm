<?php
	
	include 'connect_to_mysql.php';
	$PanicTo = array();
	
	$storedNumber = $_POST['username'];
	
	$query = "SELECT pf.*, pv.*, r.*, pv.panicMessage as pMessage from `panic_friends` pf, `panic_victim` pv, `registeration` r WHERE pv.id = pf.panicvictim_id AND pv.mynumber = '{$storedNumber}' AND r.password = pf.friendsnumber order by timestamp desc";
	$result = mysqli_query($con,$query);
	//$row=mysqli_fetch_assoc($result);
	
	while($row=mysqli_fetch_assoc($result))
	{
		array_push($PanicTo,$row);	
	}
	
	
	/*while($row=mysqli_fetch_assoc($result))
	{

		$panicToNumber = $row['friendsnumber'];
		$query_detail = "SELECT * from `panic_victim` pv , `panic_friends` pf WHERE pf.friendsnumber = '{$panicToNumber}' AND pf.panicvictim_id = pv.id AND pv.mynumber = '{$storedNumber}' ";
		$result_detail = mysqli_query($con,$query_detail);
		
		$personLog = array();
		
		while($row_details = mysqli_fetch_assoc($result_detail))
		{
			$personLog[] = $row_details;
		}
	
		$row['panic'] = $personLog;
		
		array_push($PanicTo,$row);
		
	}*/
	
	
	
	echo json_encode($PanicTo);
	
	
?>