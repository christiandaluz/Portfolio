<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Modify Activity</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round" rel="stylesheet">
    <link rel="stylesheet" href="addactivitystylev4.css">

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
    	$dbh = new PDO('pgsql:dbname=ssplanner');
	
	//Get the specific activity details from the database based on the
	//  get variable in the URL
        $st = $dbh->prepare("
	    SELECT DISTINCT * FROM category, activity 
	    WHERE $session_uid=category.clientid 
	    AND category.catid=activity.catid 
	    AND activityid={$_GET['actid']}
	");
	$st->execute();
		
	$row = $st->fetch();

	//If nothing is returned, the activity does not exist or does not
	//  belong to this user
	if (!$row) {
	    $url='dne.php';
	    header("Location: $url");
	}

	$dbh = null;
    } catch(PDOException $e) {
        print "Error: ".$e->getMessage()."<br/>";
        die();
    }
	
    print "</section>";
?>
	<div class ="container">
	    <div id="Activity Modifying">
		<h3>Modify "<?php echo $row['activityname']; ?>"</h3>
		<form method="post" action="" name="modifyactivity">

		<!-- Preset all form fields with data from database where relevant -->

		    <label>Activity Name</label>
		    <input type='text' name='actname' value="<?php echo $row['activityname']; ?>" autocomplete='off' required />
			</br>

		    <?php
			//Convert PSQL date to string and split it
			// $date = YYYY-MM-DD format
			// $time = 00:00 format
			$ts   = strtotime($row['dueby']);
			$date = date('Y-m-d', $ts);
			$time = date('H:i', $ts);
		    ?>
		    <label>Due Date</label>
		    <input type="date" name="date" value="<?php echo $date; ?>" autocomplete="off" required />
		    </br>

		    <label>Due Time</label>
		    <input type="time" name="time" value="<?php echo $time; ?>" required autocomplete="off" />
		    </br>

		    <label>Category</label>
		    <select name="category">
			<?php
			    try {
				$dbh = new PDO('pgsql:dbname=ssplanner');

				//Get the categories from the database
				$stmt = $dbh->prepare(" 
				    SELECT catname FROM category WHERE clientid=$session_uid 
				    ");
				$stmt->execute();
				$r = $stmt->fetch();
				$hasCats = $r;

				//Only show the user's categories as options
				//If the user has no categories, display message
				//The user should never be able to access this page without categories
				//Code left here as a failsafe
				if(!$r) {
				    print "<option value=nocats>No categories here...</option>";
				} else {
				    do {
					if ($r['catname'] == $row['catname']) {
					    print "<option selected='selected' value=\"".htmlentities($r['catname'])."\">{$r['catname']}</option>";
					} else {
					    print "<option value=\"".htmlentities($r['catname'])."\">{$r['catname']}</option>";
					}
				    } while ($r = $stmt->fetch());
				}

				$dbh = null;
			    } catch(PDOException $e) {
		                print "Error: ".$e->getMessage()."<br/>";
		                die();
		            }
		        ?>
		    </select>
			</br>
		    
		    
		    <label>Priority (1-5)</label>
		    <input type="number" name="priority" value="<?php echo $row['priority']; ?>" autocomplete="off" min="1" max="5" required/>
		    </br>

		    <label>Description (optional)</label>
		    <input type="text" name="description" value="<?php echo $row['description']; ?>" autocomplete="off" />
		    </br>

		    <label>Estimated Time in Minutes (optional)</label>
		    <input type="number" name="est" value="<?php echo $row['estimatedtime']; ?>" autocomplete="off" min="1"/>
		    </br>

		    <label>Completed</label>
		    <input type='checkbox' name='check' <?php if ($row['status']=='complete') { echo "checked"; } ?> >

		    <?php
			if ($hasCats) {
			    print "<input type='submit' class='button' name='activitySubmit' value='Confirm Modification'>";
			} else {
			    print "<br><h1>You must have at least one category before you can add an activity.</h1>";
			}
		    ?>
		    </form>
	    </div>
	    <div class="delete">
		<form method="post" action="deleteactivity.php?actid=<?php echo $row['activityid']; ?>" name="deleteactivity">
		    <input type='submit' class='button' name='deleteSubmit' value='Delete Activity (Action cannot be undone)'>
		</form>
	    </div>
    </div>


<?php
	    try {
		$dbh = new PDO('pgsql:dbname=ssplanner');
		if (isset($_REQUEST['actname'])) {
		    //Attempt to update with new modifications
		    $update = $dbh->prepare("
			UPDATE activity 
			SET catid=(SELECT catid FROM category WHERE catname=? AND clientid=$session_uid), activityname=?, dueby=?, priority=?, description=?, status=?, estimatedtime=?
			WHERE activityid=?
			");
	
		    $update->bindParam(1, $_REQUEST['category']);
		    $update->bindParam(2, $_REQUEST['actname']);

		    //Combine date and time to PSQL timsetamp format
		    $combinedDT = date('Y-m-d H:i:s', strtotime($_REQUEST['date'].' '.$_REQUEST['time']));

		    $update->bindParam(3, $combinedDT);
		    $update->bindParam(4, $_REQUEST['priority']);
		    $update->bindParam(5, $_REQUEST['description']);
		    
		    $status = 'incomplete';
		    if (isset($_REQUEST['check'])) {
			$status = 'complete';
		    }

		    $update->bindParam(6, $status);

		    //If estimated time is null, enter NULL instead of ""
		    $est = NULL;
		    if ($_REQUEST['est']!=="") {
			$est = $_REQUEST['est'];
		    }
		    $update->bindParam(7, $est); 
		    $update->bindParam(8, $row['activityid']);
		    
		    //Check if there are cateogires and try to execute the update
		    if ($_REQUEST['category']=='No categories here...') {
			print "<h1>You must have at least one category before you can add activities.</h1>";	
		    } else if ($update->execute()) {
			print "<h1>Activity '{$_REQUEST['actname']}' modified successfully.</h1>";
			$url="agenda.php";
			header("Location: $url");
		    } else {
			//Error message 
			print "<h1>Sorry! Looks like something has gone wrong.</h1><br>";
			
			$wrong= $update->errorInfo();
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
