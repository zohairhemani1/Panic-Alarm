<?php
	
	include 'connect_to_mysql.php';
       
	$profilePic = $_FILES['file']['name'];
	
	if($profilePic != "default.png")
	{
		move_uploaded_file($_FILES["file"]["tmp_name"], "assets/upload/" . $_FILES["file"]["name"]);
	}
	
	//echo "Stored in: " . "/assets/upload/" . $_FILES["file"]["name"] . "<br>";
	//echo "ProfilePicture: " . $profilePic;
	
	
	// Login Webservice
	
	$username = $_POST['username'];
	$password = $_POST['password'];
	
	$query = "SELECT * FROM registeration WHERE password like '{$password}'";
	$result = mysqli_query($con,$query);
	$count = mysqli_num_rows($result);
	$row = $result->fetch_object();
	$resultArray = array();
	$tempArray = array();
	
	if($count == 1)
	{
		/*$tempArray = $row;
		$tempArray['success'] = "0";
		array_push($resultArray, $tempArray);
		echo json_encode($resultArray);*/
		
		$resultArray['success'] = "0";
		echo json_encode($resultArray);
		
	}
	else if($count == 0)
	{
		$query = "INSERT INTO registeration(username,password,pic) VALUES('$username','$password','$profilePic')";
		$result = mysqli_query($con,$query);
		$resultArray['success'] = "0";
		
		echo json_encode($resultArray);
		
	}
	else
	{
		
	}
	// Close connections
	
	mysqli_close($con);
		
?>