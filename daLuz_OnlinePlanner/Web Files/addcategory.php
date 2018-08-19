<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Add a Category</title>
    	        <link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round" rel="stylesheet">

	<link rel="stylesheet" href="addcategorystylev1.css">
    <style>
    </style>
</head>

<body>
    <div class="NavigationBar">
                <a href="home.php">Home</a>
                <a href="agenda.php">Agenda</a>
                <a href="activitylist.php">All Activities</a>
                <a href="categorylist.php">All Categories</a>
                <a href="logout.php">Log Out</a>
        </div>


	<div id="container">
	    <div class="stuff">
		<h3>Add Category</h3>
		<form method="post" action="" name="addcategory">
		    <label>Category</label>
		    <input type="text" name="catname" autocomplete="off" required/>

		    <input type='submit' class='button' name='activitySubmit' value='Add Category'>
	        </form>
	    </div>
    </div>


<?php
	    try {
		$dbh = new PDO('pgsql:dbname=ssplanner');
		
		//Check if category name field is set before trying to add category
		if (isset($_REQUEST['catname'])) { 
		    //Check to see if the category name already exists for this user
		    $check = $dbh->prepare("
			SELECT catname 
			FROM category
			WHERE clientid=$session_uid AND catname=?
			");
		    $check->bindParam(1, $_REQUEST['catname']);
		    $check->execute();
		    $count = $check->rowCount();

		    //If the category name does not already exist, try to add it
		    if($count == 0) {
			$add = $dbh->prepare("
			    INSERT INTO category (clientid, catname)
			    VALUES ($session_uid, ?)
			    ");
	
			$add->bindParam(1, $_REQUEST['catname']);
		    
			//Print success message
			if ($add->execute()) {
			    print "<h1>Category '{$_REQUEST['catname']}' added successfully.</h1>";
			} else {
			    //Error message
			    print "<h1>Sorry! Looks like something has gone wrong.</h1><br>";
			
			    $wrong= $add->errorInfo();
			    foreach ($wrong as $row) {
				print "$row<br>";
			    }
			}
		    } else {
			print "<h1>Category name '{$_REQUEST['catname']}' already exists.";
		    }
		}
		$dbh = null;
	    } catch (PDOException $e) {
		print "Error: ".$e->getMessage()."<br/>";
		die();
	    }
	?>
</body>
</html>
