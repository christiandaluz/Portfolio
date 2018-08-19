<?php
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
Database usernames and passwords were unnecessary so
    they were deleted.
*/
session_start();
/* DATABASE CONFIGURATION */
define('DB_SERVER', 'localhost');
define('DB_DATABASE', 'ssplanner');
define("BASE_URL", "http://compsci.adelphi.edu/~ssplanner/");


function getDB() 
{
    $dbhost=DB_SERVER;
    $dbname=DB_DATABASE;
    
    try {
	$dbConnection = new PDO("pgsql:dbname=$dbname");
	
	$dbConnection->exec("set names utf8");
	$dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	return $dbConnection;
    } catch (PDOException $e) {
	echo 'Connection failed: ' . $e->getMessage();
    }
}
?>
