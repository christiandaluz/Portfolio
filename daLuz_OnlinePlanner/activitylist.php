<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<html>
    <head>
	        <link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round|Kavivanar" rel="stylesheet">
	<link rel="stylesheet" href="activityliststylev7.css">
	<style>
	</style>
	<title>Activity List</title>
    </head>

    <body>
	        <div class="NavigationBar">
                <a href="home.php">Home</a>
                <a href="agenda.php">Agenda</a>
                <a href="activitylist.php">All Activities</a>
                <a href="categorylist.php">All Categories</a>
                <a href="logout.php">Log Out</a>
        </div>


    <?php
	try {
	    //Connect to database
	    $dbh = new PDO('pgsql:dbname=ssplanner');

	    //Fetch user's categories and activities
	    $stmt = $dbh->prepare("SELECT category.catid, activity.catid, catname, activityid, activityname, dueby, priority, description, status, estimatedtime FROM category, activity WHERE (clientid=:cid AND category.catid=activity.catid AND (dueby >= current_timestamp)) ORDER BY dueby");
	    $stmt->bindParam("cid", $session_uid);
	    $stmt->execute();
	    //$count=$stmt->rowCount();
	    //$data=$stmt->fetch(PDO::FETCH_OBJ);

	    print "<h1>"."$userDetails->username"."'s Upcoming Activities</h1>";

	    //Print user's Activity data in a list
	    $row = $stmt->fetch();

	    //If there was nothing to fetch, then print that there are no activities
	    //	and skip the do while loop
	    if (!$row) {
		print "<h3>No activities here...</h3>";
		goto noActs;
	    }

	    do {
		//Create div for individual activity
		echo "<div class='activity'>";

		//Get the date in DOW, MM/DD 00:00AM/PM time format
		$twoday = date("l, m/d h:ia",strtotime($row['dueby']));	
		print "<h2>$twoday</h2>";

		print "<div class=\"stuff\">";
		
		//Print activity information
		print "<h4>{$row['activityname']}</h4>";
		print "<h5>{$row['catname']}</h5><br>";
		
		//If description is not null, print it; else, indicate otherwise
		if ($row['description'] != NULL)
		{
		    print "Description: {$row['description']}<br>";
		} else {
		    print "No description!<br>";
		}

		//If estimatedtime is not null, print it; else indicate otherwise
		if ($row['estimatedtime'] != NULL && $row['estimatedtime'] > 0)
		{
		    print "Estimated Time: ";
		    
		    //Get the time and convert it to hours and minutes
		    $est = $row['estimatedtime'];
                    $h = floor($est/60);
                    $m = $est%60;
                    
		    //Print time
		    if ($h > 0) {
			print "{$h}h ";
                    }
		    if ($m > 0) {
                        print "{$m}m ";
                    }

		    print "<br>";
		} else {
			print "No estimated time!<br>";
		}

		print "Priority: ";
		$p = $row['priority'];
		//Print stars according to priority level
                for ($x = 1; $x <= $p; $x++) {
		    print "<img src=\"http://www.clker.com/cliparts/M/I/J/t/i/o/star-md.png\" alt=\"star\" height=\"10\" width=\"10\">";
		}
		
		print "<br>";

		//Print checkmark if the activity was completed
		if ($row['status'] == 'incomplete') {
		    print "<p style=\"color:red;\">Incomplete</p><br>";
		} else {
		    print "<p style=\"color:green;\">Completed!</p><br>";
		}

		print "<a class='edit' href='modifyactivity.php?actid={$row['activityid']}'>Edit Activity</a>";

		//If the estimated time is greater than 30 minutes;
		//  offer the user the auto-schedule feature
		if ($row['estimatedtime'] > 30)	{
		    print "<a class='edit' href='schedule.php?actid={$row['activityid']}'>Auto-Schedule This!</a>";
		}

		print "</div>";
		print "</div>";
	    } while ($row = $stmt->fetch());

	    noActs:
	    $dbh = null;
	} catch(PDOException $e) {
		print "Error: ".$e->getMessage()."<br/>";
		die();
	}
    ?>

    <div class="divbutton">
	<button type="button" class="button" onclick="location.href='addactivity.php'">Add Activity</button>
    </div>
    
<div class="footer">
        <p><b>Spring 2018</p></b>
        <p>Adelphi University</p>
        <p>1 South Avenue, Garden City, NY, 11530</p>
</div>

</body>
</html>
