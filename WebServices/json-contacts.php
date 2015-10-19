<?php
	
	$friendsArray = array();
	
	include 'connect_to_mysql.php';
	
	$jsonArray = json_decode(stripslashes($_POST['parameterOne']), true);
	//$storedNumber = $_POST['parameterTwo'];
	$storedNumber = substr($_POST['parameterTwo'],-10);
	//echo "StoredNumber: {$storedNumber}";
	
if (is_array($jsonArray))
{
	
	foreach($jsonArray as $row)
	{
		$id = $row['id'];
		$name = $row['fullName'];
		$phone = trim(substr($row['phoneNumber'], -10));
		
		
	$query = "SELECT registeration.username, registeration.password, friends.mynumber, friends.friendsnumber, friends.activate
				FROM registeration
				LEFT OUTER JOIN friends ON friends.friendsnumber = registeration.password
				WHERE registeration.password like '%$phone'
				AND (friends.friendsnumber IS NULL or friends.mynumber not like '%$storedNumber') AND (registeration.password not like '%$storedNumber')";
	
	
		$result = mysqli_query($con,$query);
		$count = mysqli_num_rows($result);
		
		if($count == 1)
		{ 
			$query_pic = "SELECT pic from registeration WHERE password like '%$phone'";
			$result_pic = mysqli_query($con,$query_pic);
			$row_pic = mysqli_fetch_array($result_pic);
			array_push($row,$row_pic['pic']);
			
			array_push($friendsArray,$row);
		}
		
	}
}

	
	function cmp(array $a, array $b) 
	{
		if ($a['fullName'] < $b['fullName']) {
			return -1;
		} else if ($a['fullName'] > $b['fullName']) {
			return 1;
		} else {
			return 0;
		}
	}
	
	usort($friendsArray, 'cmp');
	
	echo json_encode($friendsArray);
		
?>