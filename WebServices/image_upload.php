<?php
	
	include 'connect_to_mysql.php';
       
	if (file_exists("assets/upload/" . $_FILES["file"]["name"])) 
	{
		echo $_FILES["file"]["name"] . " already exists. ";
	} 
	else 
	{
		move_uploaded_file($_FILES["file"]["tmp_name"], "assets/upload/" . $_FILES["file"]["name"]);
		echo "Stored in: " . "/assets/upload/" . $_FILES["file"]["name"] . "<br>";
		$profilePic = $_FILES['file']['name'];
		echo "ProfilePicture: " . $profilePic;
		//$query = "INSERT INTO pixrate(name,likes) VALUES('$profilePic','0')";
		//$result = mysqli_query($con,$query);
		
		//if($result)
			//echo "Inserted.";
		//else
			//echo "Error in Insertion.";
	}
    
?>