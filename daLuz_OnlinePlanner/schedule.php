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
    <link rel="stylesheet" href="addactivitystylev6.css">

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
    $st = $dbh->prepare("
        SELECT DISTINCT * FROM category, activity
        WHERE $session_uid=category.clientid
        AND category.catid=activity.catid
        AND activityid={$_GET['actid']}
        ");
    $st->execute();

    $row = $st->fetch();

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

<h1>Scheduling this activity.</h1>

<?php


    //Connect to the stuff and get the days till due
$db = new PDO('pgsql:dbname=ssplanner');
$stuff = $db->prepare("
	SELECT dueby, date_part('day', dueby - current_timestamp) AS numofdays 
	FROM activity
	WHERE activityid={$_GET['actid']}");
$stuff->execute();
$r = $stuff->fetch();


    //Get the estimated time for the activity.
$minutestocomplete = $row['estimatedtime'];
print "estimated time: ".$minutestocomplete." minutes<br>";

    //Get the number of days needed for each activity
$daystilldue = $r['numofdays'];
print "days till due: ".$daystilldue."<br>";

    //Calculate minutes per day
$minutesperday = (int) ((double) $minutestocomplete / $daystilldue);
print "minutes per day: ".$minutesperday."<br>";

    //Adding the activities...
if ($daystilldue > 0)
{
	for ($i = $daystilldue; $i > 0; $i--) {
       $add = $db->prepare("
          INSERT INTO activity 
          (catid, activityname, dueby, priority, description, status, estimatedtime) 
          VALUES 
          (:catid, :actname, date '{$row['dueby']}' - interval '{$i} day', :priority, 'This is an auto-scheduled activity', 'incomplete', :mpd)");
       
       $add->bindParam(':catid', $row['catid']);
       
       $name = "Work on \"".htmlentities($row['activityname'])."\" for {$minutesperday} minutes";
       $add->bindParam(':actname', $name);
       
       $add->bindParam(':priority', $row['priority']);
       $add->bindParam(':mpd', $minutesperday);
       
       if ($add->execute()) {
          print "Success!<br>";
          $url ="agenda.php";
          header("Location: $url");
      } else {
          $wrong = $add->errorInfo();
          foreach ($wrong as $row)
          {
              print "$row<br>";
          }
      }
  }
}
?>

</body>
</html>
