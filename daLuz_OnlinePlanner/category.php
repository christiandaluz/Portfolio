<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<html>
    <head>
	<link rel="stylesheet" href="activityliststyle.css">
	<style>
	</style>
	<title>Category</title>
    </head>

    <body>
<?php
	print "<pre>";
?>

    <?php
	try {
	    //Connect to database
	    $dbh = new PDO('pgsql:dbname=ssplanner');

	    //Fetch user's categories and activities
	    $stmt = $dbh->prepare("
		SELECT clientid, category.catid, activity.catid, catname, activityid, activityname, dueby, priority, description, status, estimatedtime 
		FROM category, activity 
		WHERE (clientid=:cid AND category.catid=activity.catid AND category.catid={$_GET['catid']}) 
		ORDER BY dueby");
	    $stmt->bindParam("cid", $session_uid);
	    $stmt->execute();
	    //$count=$stmt->rowCount();
	    //$data=$stmt->fetch(PDO::FETCH_OBJ);

	    print "<h1>"."$userDetails->username"."'s Activities</h1>";

	    //Print user's Activity data in a list
	    $row = $stmt->fetch();

	    //If there was nothing to fetch, then print that there are no activities
	    //	and skip the do while loop
	    if (!$row) {
		print "<h3>No activities here...</h3>";
		goto noActs;
	    }
	    $day = $row['dueby'];

	    //$date = $db->prepare("SELECT EXTRACT(dow FROM dueby) AS dow, EXTRACT(month FROM dueby) AS month, EXTRACT(day FROM dueby) AS day, EXTRACT(hour FROM dueby) AS hour, EXTRACT(minute FROM dueby) AS minute FROM activity WHERE 
	    print "<h2>{$row['dueby']}</h2>";
	    do {
		if ($day != $row['dueby']) {
		    print "<h2>{$row['dueby']}</h2>";
		    $day = $row['dueby'];
		}

		print "<div>";
		print "Category: {$row['catname']}<br>";
		print "Activity Name: {$row['activityname']}<br>";
		print "Priority: {$row['priority']}<br>";
		print "Description: {$row['description']}<br>";
		print "Status: {$row['status']}<br>";
		print "Estimated Time: {$row['estimatedtime']}<br>";
		print "<br>";
	    } while ($row = $stmt->fetch());

	    noActs:
	    $dbh = null;
	} catch(PDOException $e) {
		print "Error: ".$e->getMessage()."<br/>";
		die();
	}
    ?>

    <a href="home.php">Home</a><br>
    <a href="logout.php">Log Out</a>

    </body>
</html>
