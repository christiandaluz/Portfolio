<?php
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
*/
if(!empty($_SESSION['uid'])) {
    $session_uid=$_SESSION['uid'];
    include('class/userClass.php');
    $userClass = new userClass();
}

//If the session id is blank, always reroute to log in page
if(empty($session_uid)) {
    $url='index.php';
    header("Location: $url");
}
?>
