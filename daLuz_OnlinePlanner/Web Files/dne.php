<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>

<!DOCTYPE html>
<html>
    <head>
	<link rel="stylesheet" href="styles.css">
	<style>
	</style>
	<title>Something has gone wrong...</title>
    </head>
    <body>
	<h1>Something has gone wrong...</h1>
	<p>The activity or category you are trying to modify does not appear to exist. Please try again.</p>
	<a href="home.php">Home</a><br>
	<a href="logout.php">Log Out</a>
    </body>
</html>
