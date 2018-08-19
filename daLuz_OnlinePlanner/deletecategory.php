<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);

try {
    $dbh = new PDO('pgsql:dbname=ssplanner');

    //Select the clientid for a category with an id matching
    //	    that in the URL GET variable
    $verify = $dbh->prepare("
	SELECT client.clientid FROM client, category 
	WHERE catid=? AND client.clientid=category.clientid
	");
    $verify->bindParam(1, $_GET['categoryid']);
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
    }//end if
     else {
	//Prepare a statement to check for activities in the category
        $check = $dbh->prepare("
	    SELECT activityid 
	    FROM activity, category
	    WHERE activity.catid=category.catid
	    AND category.catid = {$_GET['categoryid']}");
	$check->execute();
	$checkr = $check->fetch();

	//If there are no activities in the category, delete category
	//Otherwise user must delete activities
	//  Not sure if this is the best way to go about this. 
	//  Concern over deleting category with many old activities. Cd.
	if (!$checkr) {
	    $st = $dbh->prepare("
		DELETE FROM category
		WHERE catid=?
		");
	    $st->bindParam(1, $_GET['categoryid']);
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
	    }//end else
	}//end if !checkr
	else {
	    print "This category cannot be deleted because it has activities in it. Delete all activities in this category before deleting.";
	} //end else
    }

    $dbh = null;
} catch(PDOException $e) {
    print "Error: ".$e->getMessage()."<br/>";
    die();
}
?>	
