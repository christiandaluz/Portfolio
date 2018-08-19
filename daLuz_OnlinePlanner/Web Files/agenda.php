<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<!DOCTYPE html>
<html>
<head>

	<!-- CSS Stylesheets and Google Fonts -->
	<link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round|Kavivanar|Patrick+Hand" rel="stylesheet">
    	<link rel = "stylesheet" href = "agendastylev10.css" type = "text/css" />

	<title>Weekly Agenda</title>
</head>

<body>
<?php
	//Connect to database and select this Monday's date and this Sunday's date.
	//month1 = this Monday's month date (*X*/y)
	//date1 = this Monday's day date  (y/*X*)
	//month2 = this Sunday's month date (*X*/y)
	//date2 = this Sunday's day date (y/*X*)
    try {
    	$dbh = new PDO('pgsql:dbname=ssplanner');

	//Variable to test if default week should be used or week via GET variables
	//  If there are no GET variables, executed remains false
	//  If the GET variables cannot be resolved to a date, executed remain false
	$executed = false;

	if (!empty($_GET["y"]) && !empty($_GET["m"]) && !empty($_GET["d"])) {
	    //Form the week into a date string from the GET variables, then convert it
	    //	to a date for the PSQL query
	    $week = "{$_GET['y']}-{$_GET['m']}-{$_GET['d']} 00:00:00";
	    $week = date("Y-m-d H:i:s", strtotime($week));

	    $stmt = $dbh->prepare("SELECT 
		DATE_PART('MONTH',DATE_TRUNC('WEEK', TIMESTAMP '$week')) AS month1, 
		DATE_PART('DAY', DATE_TRUNC('WEEK', TIMESTAMP '$week')) AS date1,
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', TIMESTAMP '$week') + INTERVAL '6 day')) AS month2, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', TIMESTAMP '$week') + INTERVAL '6 day')) AS date2 
		");	    
	    $executed = $stmt->execute();

	    if (!$executed) {
		$wrong = $stmt->errorInfo();
		foreach ($wrong as $row) {
		    print "$row<br>";
		}
	    }
	} 
	
	//If executed is false, default to current week
	if (!$executed) {
	    $stmt = $dbh->prepare("SELECT 
		DATE_PART('MONTH',DATE_TRUNC('WEEK', CURRENT_DATE)) AS month1, 
		DATE_PART('DAY', DATE_TRUNC('WEEK', CURRENT_DATE)) AS date1,
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', CURRENT_DATE) + INTERVAL '6 day')) AS month2, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', CURRENT_DATE) + INTERVAL '6 day')) AS date2 
		");
	    $stmt->execute();
	}
	    
	$r = $stmt->fetch();
    ?>
	<!-- Display Navigation bar at top of page. -->
	<div class="NavigationBar">
		<a href="home.php">Home</a>
		<a href="agenda.php">Agenda</a>
        	<a href="activitylist.php">All Activities</a>
       		<a href="categorylist.php">All Categories</a>
        	<a href="logout.php">Log Out</a>
	</div>


    	<div class="date">
<?php
	//Print month1, date1, month2, date2 to show this week's Monday-Sunday dates.
	print "<h2>Week of: {$r['month1']}"."/"."{$r['date1']}"." - "."{$r['month2']}"."/"."{$r['date2']}</h2>";
?>
    	</div>
    	<section class="container">

<?php
	//Array for the name of the day of week. Runs through the array to list the day of the week
	$dow = array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

	//Run through 7 times (one for each day of week.)
	//Connect to database for each iteration and continue to go on to
	//print the day name and a table of activities.
	for ($i = 1; $i <= 7; $i++) {
	    //If executed is true, use custom week; otherwise, default to current week
	    //Query gets all data for an activity from activity and category relations
	    if ($executed) {
		$st = $dbh->prepare("
		    SELECT * FROM category, activity 
		    WHERE $session_uid=category.clientid 
		    AND category.catid=activity.catid 
		    AND EXTRACT(ISODOW FROM dueby) = $i
		    AND DATE_TRUNC('WEEK', TIMESTAMP '$week') = DATE_TRUNC('WEEK', dueby)
		    ");
		
		$wrong = $st->errorInfo();
		foreach ($wrong as $row) {
		    print "$row<br>";
		}
	    } else {
		$st = $dbh->prepare("
		    SELECT * FROM category, activity 
		    WHERE $session_uid=category.clientid 
		    AND category.catid=activity.catid 
		    AND EXTRACT(ISODOW FROM dueby) = $i
		    AND DATE_PART('WEEK', CURRENT_DATE) = DATE_PART('WEEK', dueby)
		    ");
	    }

	    $st->execute();
	    $row = $st->fetch();
	    $index = $i - 1;

	    //If the current day, using the php function date, is the day being
	    //	printed, make the div name "today" (for CSS purposes. The current
	    //	day (div class "today") is surrounded by a dotted border. The
	    //	regular div has a solid border.
	    if ($dow[$index] == date("l")){ 
	    ?>
		<div class="today">
	    <?php
 	    } else {
		print "<div>";
	    }
	    
	    //Print the table for the day's activities.
	    print "<table id='tableId' border=1>";
	    
	    //Print the day name (i.e. Monday) based on the array above.
	    print "<h1>$dow[$index]</h1>";

	    //If there are no activities, print a "Nothing to do" message.
	    //Else, print the table of activities.
	    if (!$row) {
	        print "<tr><td>Nothing to do! :)</td></tr>";
	    } else {
	        do {
		    print "<tr>";
		    
		    //The td class "First" is used to make the name of the activity larger 
		    //	than the other cells in the table. If you click on the name of the
		    //	activity, it runs the Javascript function "openDiv." Basically, 
		    //	openDiv takes in the name of a div (which is generated based on 
		    //	the activityid in the database, so every div class name is unique)
		    //	and the function opens up a tablebody type of other information 
		    //	corresponding to that activity.
		    print "<td class='first'><button class='activitynamebutton' onclick=\"openDiv('div{$row['activityid']}')\">";
		    print "<b>{$row['activityname']}</b></button></td>";

		    //Print the category name in another cell
		    print "<td>{$row['catname']}</td>";
	    ?>
		    <td class="checkmark">
	    <?php

		    //Checks the status of the activity ("complete" or "incomplete") and 
		    //	uses Javascript function "clickCheck" to see if it is 
		    //	checked/unchecked.
		    //If complete, show a green checkmark.
		    //If incomplete, show a black-bordered circle.
		    if (strcmp($row['status'], 'incomplete') == 0) {
			print "<img id='check{$row['activityid']}' src='circle.png' alt='' style='width:25px'>";
		    } else {
			print "<img id='check{$row['activityid']}' src='check.png' alt='' style='width:25px'>";
		    }
	

		    print "</td>";
	
		    //When the name of the activity is clicked on, this tbody should show up.
		    //It has a unique id based on activityid. Display initially is set 
		    //	to none.
                    print "<tbody class ='displayDiv' id='div{$row['activityid']}' style=\"display:none;\">";

			//These are the table cells that appear when the Javascript function
			//  openDiv is called.
			print "<td class=\"stuff\">";

			//p = the activity's priority. Priority is between 1 and 5 and is 
			//  represented by teeny tiny stars.
			$p = $row['priority'];
			
			//Print the number of stars relative to priority
			for ($c = 1; $c <= $p; $c++) {
			    print "<img src=\"http://www.clker.com/cliparts/M/I/J/t/i/o/star-md.png\" alt=\"star\" height=\"10\" width=\"10\">";
			}
				
			print "</td>";


			//If the activity has a user-inputted description, it should print
			//  it. If not, print "No Description"
			if ($row['description'] != NULL) {
			    print "<td class=\"stuff\">Description: {$row['description']}</td>";
			} else {
			    print "<td class=\"stuff\">No description!</td>";
			}

			//If the activity has a user-inputted estimated time, it should
			//  print it in the format "Xh Xm" or "Xm" or "Xh".
			//  If not,it should print "No estimated time"
			if ($row['estimatedtime'] != NULL) {
			    print "<td class=\"stuff\">Estimated Time: ";

			    //est = the activity's estimated time in minutes.
			    $est = $row['estimatedtime'];
			    
			    //Round down the division by 60 to get the number of hours.
			    $h = floor($est/60);
			    //The remainder is the number of minutes.
			    $m = $est%60;

			    //If the hours is greater than zero, print the number of hours. 
			    if ($h > 0) {
			    	print "{$h}h ";
			    }
			    if ($m > 0) {
				print "{$m}m ";
			    }
			
			    print "</td>";
                    	} else {
			    print "<td class=\"stuff\">No estimated time!</td>";
			}
			
			print "<td class='stuff'><a class='edit' href='modifyactivity.php?actid={$row['activityid']}'>Edit Activity</a></td>";
			
		    print "</tbody>";
		    print "</tr>";
		    print "</div>";
		} while ($row = $st->fetch());
	    }

	    print "</table>";
	    print "</div>";
	}
	
	print "</section>";
    ?>

    <div class="divbutton">
    <button type="button" class="button" onclick="location.href='addactivity.php'">Add Activity</button>
    </div>
    
    <?php
	//Creating navigation bar to other weeks:
	//If executed is true, create navigation buttons using GET variables
	//  Otherwise, use current date
	if ($executed) {
	    $st = $dbh->prepare("SELECT 
		DATE_PART('YEAR', (DATE_TRUNC('WEEK', TIMESTAMP '$week') - INTERVAL '7 day')) AS ly, 
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', TIMESTAMP '$week') - INTERVAL '7 day')) AS lm, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', TIMESTAMP '$week') - INTERVAL '7 day')) AS ld,
		DATE_PART('YEAR', (DATE_TRUNC('WEEK', TIMESTAMP '$week') + INTERVAL '7 day')) AS ny, 
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', TIMESTAMP '$week') + INTERVAL '7 day')) AS nm, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', TIMESTAMP '$week') + INTERVAL '7 day')) AS nd 
		");
	    $st->execute();
	    $stmt=$st->fetch();

	    //The actual navigation bar
	    print "<div class='NavigationBar'>";
	    print "<a href='agenda.php?y={$stmt['ly']}&m={$stmt['lm']}&d={$stmt['ld']}'>Last Week</a>";
	    print "<a href='agenda.php'>Current Week</a>";
	    print "<a href='agenda.php?y={$stmt['ny']}&m={$stmt['nm']}&d={$stmt['nd']}'>Next Week</a>";
	    print "</div>";
	} else {
	    $st = $dbh->prepare("SELECT 
		DATE_PART('YEAR', (DATE_TRUNC('WEEK', CURRENT_DATE) - INTERVAL '7 day')) AS ly, 
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', CURRENT_DATE) - INTERVAL '7 day')) AS lm, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', CURRENT_DATE) - INTERVAL '7 day')) AS ld,
		DATE_PART('YEAR', (DATE_TRUNC('WEEK', CURRENT_DATE) + INTERVAL '7 day')) AS ny, 
		DATE_PART('MONTH', (DATE_TRUNC('WEEK', CURRENT_DATE) + INTERVAL '7 day')) AS nm, 
		DATE_PART('DAY',(DATE_TRUNC('WEEK', CURRENT_DATE) + INTERVAL '7 day')) AS nd 
		");
	    $st->execute();
	    $stmt=$st->fetch();
		
	    //The actual navigation bar
	    print "<div class='NavigationBar'>";
	    print "<a href='agenda.php?y={$stmt['ly']}&m={$stmt['lm']}&d={$stmt['ld']}'>Last Week</a>";
	    print "<a href='agenda.php'>Current Week</a>";
	    print "<a href='agenda.php?y={$stmt['ny']}&m={$stmt['nm']}&d={$stmt['nd']}'>Next Week</a>";
	    print "</div>";

	}

	$dbh = null;
	} catch(PDOException $e) {
            print "Error: ".$e->getMessage()."<br/>";
            die();
        }
    ?>



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
