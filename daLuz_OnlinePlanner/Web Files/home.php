<?php
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
Code now shows links to our planner.
*/
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>

<!DOCTYPE html>
<html>
    <head>
	<!-- This is for the CSS Stylesheet and Google Fonts used. -->
	<link href="https://fonts.googleapis.com/css?family=Montserrat|Varela+Round|Kavivanar" rel="stylesheet">
	<link rel="stylesheet" href="homepagestylev8.css">
	<title>Planner Homepage</title>
    </head>
    <body>

	<!-- Div for the title of the page -->
	<div class="title">

	<!-- Greets the user with their registered username -->
	<h2>Welcome, <?php echo $userDetails->username; ?>!</h2><br>

	<p class="day">
<?php
	//Prints "Today is *date*. Ready to be productive?
	print "Today is ";
	print date("l, m/d");
	print ". Ready to be productive?";
?>
	</p>
	</div>
	<div class="homepage">
	<a href="agenda.php">

	<!-- Div for the first clickable box. Leads to Agenda.php -->

	<div class="idk">
	View Weekly Planner<br>
	<img src="https://i.gyazo.com/f1229b133d49cc600da728372d0b5867.png" alt="agendapic">
	</div>
	</a>

	<!-- Div for second clickable box. Leads to ActivityList.php -->

	<a href="activitylist.php">
	<div class="idk">
	View All Upcoming Activities<br>
	<img src="https://i.gyazo.com/93a63fcd450d5fa300a563c57f57dca3.png" alt="listpic">
	</div>
	</a>

	<!-- Div for third clickable box. Leads to CategoryList.php -->

	<a href="categorylist.php">
	<div class="idk">
	View All Categories<br>
	<img src="https://i.gyazo.com/487d53ba7e7bc9d69d79c56239785411.png" alt="listpic">
	</div>
	</a>

	<!-- Logout -->

	<a href="logout.php">
	<div class="idk">
	Log Out</div>
	</a>
	</div>

<div class="footer">
        <p><b>Spring 2018</p></b>
        <p>Adelphi University</p>
        <p>1 South Avenue, Garden City, NY, 11530</p>
        </div>




</body>
</html>
