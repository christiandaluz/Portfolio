<?php
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
*/
include('config.php');

$session_uid='';
$_SESSION['uid']=''; 

//Redirect to log in page if session user id is blank
if(empty($session_uid) && empty($_SESSION['uid'])) {
    $url='index.php';
    header("Location: $url");
}
?>
