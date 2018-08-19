<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>
<!DOCTYPE html>
<html>
<head>
        <link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round" rel="stylesheet">
	<link rel = "stylesheet" href = "addactivitystylev4.css" type = "text/css" />
    <title>Add an Activity</title>
</head>

<body>
        <div class="NavigationBar">
                <a href="home.php">Home</a>
                <a href="agenda.php">Agenda</a>
                <a href="activitylist.php">All Activities</a>
                <a href="categorylist.php">All Categories</a>
                <a href="logout.php">Log Out</a>
        </div>

    <div class ="container">
	    <div id="Activity Adding">
		<h3>Add Activity</h3>
		<form method="post" action="" name="addactivity">
		    <label>Activity Name</label>
		    <input type="text" name="actname" autocomplete="off" required autofocus/>
			</br>

		    <!-- Preset date to today's date -->
		    <label>Due Date</label>
		    <input type="date" name="date" autocomplete="off" value=<?php echo date('Y-m-d'); ?> min=<?php echo date('Y-m-d'); ?> required />
		    </br>
    
		    <!-- Preset time to 12AM -->
		    <label>Due Time</label>
		    <input type="time" name="time" value="00:00" autocomplete="off" required />
		    </br>

		    <label>Category</label>
		    <select name="category">
			<?php
			    //Get the users categories to display
			    try {
				$dbh = new PDO('pgsql:dbname=ssplanner');
				$stmt = $dbh->prepare(" 
				    SELECT catname FROM category WHERE clientid=$session_uid 
				    ");
				$stmt->execute();
				$r = $stmt->fetch();
				$hasCats = $r;

				//Only show the user's categories as options
				//If the user has no categories, display message
				if(!$r) {
				    print "<option value=nocats>No categories here...</option>";
				} else {
				    do {
					print "<option value=\"".htmlentities($r['catname'])."\">{$r['catname']}</option>";
				    } while ($r = $stmt->fetch());
				}

				$dbh = null;
			    } catch(PDOException $e) {
		                print "Error: ".$e->getMessage()."<br/>";
		                die();
		            }
		        ?>
		    </select>

		    <!-- Allow user to go to add category page -->
			<a class="addcat" href="addcategory.php">Add New Category</a>
			</br>
		    		    
		    <!-- Preset priority to 1 -->
		    <label>Priority (1-5)</label>
		    <input type="number" name="priority" autocomplete="off" value="1" min="1" max="5" required/>
		    </br>

		    <label>Description (optional)</label>
		    <input type="text" name="description" autocomplete="off" />
		    </br>

		    <label>Estimated Time in Minutes (optional)</label>
		    <input type="number" name="est" autocomplete="off" min="1"/>

		    </br>

		    <label>Completed</label>
		    <input type='checkbox' name='check'>

		    <?php
			//Do not allow the user to submit an activity unless
			//  they have categories.
			if ($hasCats) {
			    print "<input type='submit' class='button' name='activitySubmit' value='Add Activity'>";
			} else {
			    print "<br><h1>You must have at least one category before you can add an activity.</h1>";
			}
		    ?>
	        </form>
	    </div>
    </div>


<?php
	    try {
		$dbh = new PDO('pgsql:dbname=ssplanner');

		//Check if the activity name input field is filled before 
		//  attempting to add an activity
		if (isset($_REQUEST['actname'])) {
		    $add = $dbh->prepare("
			INSERT INTO activity (catid, activityname, dueby, priority, description, status, estimatedtime)
			VALUES ((SELECT catid FROM category WHERE catname=? AND clientid=$session_uid), ?, ?, ?, ?, ?, ?)
			");
	
		    $add->bindParam(1, $_REQUEST['category']);
		    $add->bindParam(2, $_REQUEST['actname']);

		    //Combine date and time to PSQL timsetamp format
		    $combinedDT = date('Y-m-d H:i:s', strtotime($_REQUEST['date'].' '.$_REQUEST['time']));
		    $add->bindParam(3, $combinedDT);

		    $add->bindParam(4, $_REQUEST['priority']);
		    $add->bindParam(5, $_REQUEST['description']);
		    
		    //Determine if checkbox is checked to assign status
		    $status = 'incomplete';
		    if (isset($_REQUEST['check'])) {
			$status = 'complete';
		    }
		    $add->bindParam(6, $status);
		     
		    //If estimated time field is blank, enter NULL instead of ""
		    $est = NULL;
		    if ($_REQUEST['est']!=="") {
			$est = $_REQUEST['est'];
		    }
		    $add->bindParam(7, $est); 
		    
		    //Display conditional completion message
		    if ($_REQUEST['category']=='No categories here...') {
			echo "<script type='text/javascript'>alert('You must have at least one category.');</script>";	
		    } else if ($add->execute()) {
			echo "<script type='text/javascript'>alert('Activity added successfully!');</script>";
		    } else {
			//Error message
			echo "<script type='text/javascript'>alert('Sorry! Looks like something has gone wrong.');</script>";
			
			$wrong= $add->errorInfo();
			foreach ($wrong as $row) {
			    print "$row<br>";
			}
		    }
		}
		$dbh = null;
	    } catch (PDOException $e) {
		print "Error: ".$e->getMessage()."<br/>";
		die();
	    }
	?>
	</br>
</body>
</html>
