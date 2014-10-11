<?php
	
	$friendsArray = array();
	
	$con=mysqli_connect("localhost","iospanic","Hemani786!","iospanic");
	if (mysqli_connect_errno())
	{
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$jsonArray = json_decode($_POST['parameterOne']);
	$storedNumber = $_POST['username'];
	
	foreach($jsonArray as $row)
	{
		$id = $row->id;
		$name = $row->fullName;
		$phone = $row->phoneNumber;
		
		//$query = "SELECT * from registeration WHERE password like '$phone'";
		/*$query = "SELECT distinct registeration.id,registeration.username,registeration.password,friends.mynumber,friends.activate
					FROM registeration
					LEFT OUTER JOIN friends
 				  ON friends.friendsnumber=registeration.password WHERE registeration.password='$phone' AND friends.activate IS NULL";*/
				  
		$query = "SELECT distinct registeration.id,registeration.username,registeration.password,friends.mynumber,friends.friendsnumber,
					friends.activate
					FROM registeration
					LEFT OUTER JOIN friends
 				  ON friends.friendsnumber=registeration.password WHERE registeration.password='$phone' AND ((friends.mynumber != '$storedNumber' AND friends.activate!=1) OR friends.activate IS NULL)";
		$result = mysqli_query($con,$query);
		$count = mysqli_num_rows($result);
		
		if($count == 1)
		{ 
			//echo "1";
			array_push($friendsArray,$row);
		}
		else
		{
			//echo "0";
		}
			
	}
	
	echo json_encode($friendsArray);
		
?>