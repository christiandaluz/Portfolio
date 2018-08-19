<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<html>
    <head>
	<title>Category List</title>
	<link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round|Kavivanar" rel="stylesheet">
	<link rel="stylesheet" href="categoryliststylev6.css">
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

	//print every category
	try {
	    //Connect to database
	    $dbh = new PDO('pgsql:dbname=ssplanner');

	    //Fetch user's categories
	    $st = $dbh->prepare("SELECT catname, catid FROM category WHERE (category.clientid=:cid) ORDER BY catname ASC");
	    $st->bindParam("cid", $session_uid);
	    $st->execute();

	    //Display personalized user message
	    print "<h1>"."$userDetails->username"."'s Categories</h1>";

	    $row = $st->fetch();

	    //Determine if user has categories and indicate if there are none
	    if (!$row) {
		print "<h3>No categories here...</h3>";
		goto noCats;
	    }

	    do {
		//Makes a button with the name of the category and makes a div with the id of that category
		print "<button onclick=\"openDiv('".htmlentities($row['catid'])."')\">";
		print "{$row['catname']}</button>";
 		print "<div id=\"".htmlentities($row['catid'])."\" style=\"display:none;\">";

		//print "<h2><a href='category.php?catid={$row['catid']}'>{$row['catname']}</a></h2><br>";
		try {
		    $dbh = new PDO('pgsql:dbname=ssplanner');

		    //Get all of the upcoming activities for each individual category
		    $stmt = $dbh->prepare("
			SELECT clientid, category.catid, activity.catid, catname, activityid, activityname, dueby, priority, description, status, estimatedtime
                	FROM category, activity
                	WHERE (clientid=:cid AND category.catid=activity.catid AND category.catname='{$row['catname']}' AND activity.dueby >= current_timestamp)
                	ORDER BY dueby");
		    $stmt->bindParam("cid", $session_uid);
		    $stmt->execute();

		    $r = $stmt->fetch();

		    //If there are no activities, indicate so and skip do while loop
		    if (!$r) {
                	print "<h3>No activities here...</h3>";
        	        goto noActs;
		    }

		    // $day = PSQL dueby date
		    // $twoday = date in DOW, MM/DD 00:00AM/PM format
		    $day = $r['dueby'];
		    $twoday = date("l, m/d h:ia",strtotime($day));

		    //Print the date
		    print "<h2>$twoday</h2>";
		    do {
			//This if block should never execute because $day is
			//  set to $r['dueby'] above
                	if ($day != $r['dueby']) {
                    	    $day = $r['dueby'];
			    $twoday = date("l, m/d h:ia",strtotime($day));
			    print "<h2>$twoday</h2>";
			    //$day = $r['dueby'];
                	}

			//print "<div>";
			print "<h3>{$r['activityname']}</h3><br>";
			
			print "Priority: ";
			$p = $r['priority'];
			//Print stars according to priority level
			for ($x = 1; $x <= $p; $x++) {
			    print "<img src=\"http://www.clker.com/cliparts/M/I/J/t/i/o/star-md.png\" alt=\"star\" height=\"10\" width=\"10\">";
			}
			
			print "<br>";

			//Indicate if the description is blank
			if ($r['description'] != NULL) {
			    print "Description: {$r['description']}<br>";
                        } else {
                            print "No description!<br>";
                        }

			//Display estimated time in Xh Xm format, or indicate if blank
			if ($r['estimatedtime'] != NULL) {
                            print "Estimated Time: ";
			    $est = $r['estimatedtime'];
			    $h = floor($est/60);
			    $m = $est%60;
			    print "{$h}h {$m}m<br>";
                        } else {
                            print "No estimated time!<br>";
                        }

			//Indicate status
			if ($r['status'] == 'incomplete') {
			    print "<p style=\"color:red;\">Incomplete</p>";
			} else {
			    print "<p style=\"color:green;\">Complete</p>";
			}

			print "<a class=\"edit\" href='modifyactivity.php?actid={$r['activityid']}'>Edit Activity</a>";

		    //print "</div>";
		} while ($r = $stmt->fetch());

	noActs:
        $dbh = null;
        } catch(PDOException $e) {
                print "Error: ".$e->getMessage()."<br/>";
                die();
        }

		print "<br>";
		print "<a class=\"editcat\" href='modifycategory.php?categoryid={$row['catid']}'>Edit Category</a>";
		print "</div>";
		} while($row = $st->fetch()); 

	    noCats:
	} catch(PDOException $e) {
	    print "Error: ".$e->getMessage()."<br>";
	    die();
	}
    ?>


  <div class="divbutton">
    <button type="button" class="button" onclick="location.href='addcategory.php'">Add Category</button>
    </div>



<div class="footer">
        <p><b>Spring 2018</p></b>
        <p>Adelphi University</p>
        <p>1 South Avenue, Garden City, NY, 11530</p>
</div>



<script>
function openDiv(x) {
	var y = document.getElementById(x);
	if (y.style.display === "none") {
		y.style.display = "block";
	} else {
		y.style.display = "none";
	}
}
</script>





    </body>
</html>
