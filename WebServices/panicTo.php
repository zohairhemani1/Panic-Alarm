<?php
	
	include 'connect_to_mysql.php';
	$PanicTo = array();
	
	$query = "SELECT * from `panic_friends` pf, `panic_victim` pv WHERE pv.id = pf.panicvictim_id AND pv.mynumber = '090078601' group by pf.friendsnumber";
	$result = mysqli_query($con,$query);
	
	while($row=mysqli_fetch_assoc($result))
	{

		$panicToNumber = $row['friendsnumber'];
		$query_detail = "SELECT * from `panic_victim` pv , `panic_friends` pf WHERE pf.friendsnumber = '{$panicToNumber}' AND pf.panicvictim_id = pv.id ";
		$result_detail = mysqli_query($con,$query_detail);
		
		$personLog = array();
		
		while($row_details = mysqli_fetch_assoc($result_detail))
		{
			$personLog[] = $row_details;
		}
	
		$row['panic'] = $personLog;
		
		array_push($PanicTo,$row);
		
		
	}
	
	echo json_encode($PanicTo);
	
	
?>