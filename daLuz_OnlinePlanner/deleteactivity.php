<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);

try {
    $dbh = new PDO('pgsql:dbname=ssplanner');

    //Select the clientid for an activity with an id matching
    //	    that in the URL GET variable
    $verify = $dbh->prepare("
	SELECT client.clientid FROM client, category, activity 
	WHERE activityid=? AND client.clientid=category.clientid 
	AND category.catid=activity.catid
	");
    $verify->bindParam(1, $_GET['actid']);
    $verify->execute();
    $st = $verify->fetch();
    
    //If there is an error, print error info
    $wrong= $verify->errorInfo();
    foreach ($wrong as $row) {
	print "$row<br>";
    }	

    //Check if the statement has returned something and
    //	    if the clientid is not the same as the
    //	    session id. If either of these is true, 
    //	    redirect to the does not exist page
    if (!$st || ($st['clientid'] !== $session_uid)) {
        $url='dne.php';
        header("Location: $url");
    } else {
	//Prepare a statement to delete the activity
        $st = $dbh->prepare("
	    DELETE FROM activity 
	    WHERE activityid=?
	    ");
	$st->bindParam(1, $_GET['actid']);
	$st->execute();
	
	//If the statement does not return anything, 
	//	redirect to does not exist page.
	//	Otherwise, redirect back to agenda page
	if (!$st) {
	    $url='dne.php';
	    header("Location: $url");
	} else {
	    $url='agenda.php';
	    header("Location: $url");
	}
    }

    $dbh = null;
} catch(PDOException $e) {
    print "Error: ".$e->getMessage()."<br/>";
    die();
}
?>	
