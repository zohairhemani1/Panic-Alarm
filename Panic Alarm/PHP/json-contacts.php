<?php
	
	$friendsArray = array();
	
	$con=mysqli_connect("iospanic.db.11683817.hostedresource.com","iospanic","Hemani786!","iospanic");
	if (mysqli_connect_errno())
	{
	 // echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}
	
	$jsonArray = json_decode(stripslashes($_POST['parameterOne']), true);
	$storedNumber = $_POST['username'];
	
	
if (is_array($jsonArray))
{
	
	foreach($jsonArray as $row)
	{
		$id = $row['id'];
		$name = $row['fullName'];
		$phone = $row['phoneNumber'];
		
		/*$query = "SELECT distinct registeration.id,registeration.username,registeration.password,friends.mynumber,friends.activate
					FROM registeration
					LEFT OUTER JOIN friends
 				  ON friends.friendsnumber=registeration.password WHERE registeration.password='$phone' AND friends.activate IS NULL";*/
				  
	/*	$query = "SELECT distinct registeration.id,registeration.username,registeration.password,friends.mynumber,friends.friendsnumber,
					friends.activate
					FROM registeration
					LEFT OUTER JOIN friends
 				  ON friends.friendsnumber=registeration.password WHERE registeration.password='$phone' AND ((friends.mynumber != '$storedNumber' AND friends.activate!=1) OR friends.activate IS NULL)";
	*/			  
	
		$query = "SELECT registeration.id, registeration.username, registeration.password, friends.mynumber, friends.friendsnumber, friends.activate
				FROM registeration
				LEFT OUTER JOIN friends ON friends.friendsnumber = registeration.password
				WHERE registeration.password = '$phone'  
				AND (friends.friendsnumber IS NULL or friends.mynumber!='$storedNumber')) and registeration.password != '$storedNumber'";
					
	
		$result = mysqli_query($con,$query);
		$count = mysqli_num_rows($result);
		
		if($count == 1)
		{ 
			//echo "1";
			$query_pic = "SELECT pic from registeration WHERE password like '$phone'";
			$result_pic = mysqli_query($con,$query_pic);
			$row_pic = mysqli_fetch_array($result_pic);
			array_push($row,$row_pic['pic']);
			//echo "This is the row -->".$row;
			
			array_push($friendsArray,$row);
		}
		
	}
}
	echo json_encode($friendsArray);
		
?>