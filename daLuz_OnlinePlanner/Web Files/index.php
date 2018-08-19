<?php 
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
*/
include("config.php");
include('class/userClass.php');

//If there is a session user id, the user is already logged in and should be
//  redirected to the homepage
if(!empty($_SESSION['uid'])) {
    $url='home.php';
    header("Location: $url");
}

$userClass = new userClass();

$errorMsgReg='';
$errorMsgLogin='';

//If the user has submitted log in credentials
if (!empty($_POST['loginSubmit'])) {
    //Get username/email and password
    $usernameEmail=$_POST['usernameEmail'];
    $password=$_POST['password'];

    //Trim whitespace and make sure username/email and password are greater than
    //	one character in length
    if(strlen(trim($usernameEmail))>1 && strlen(trim($password))>1 ) {
	//Attempt to log user in via userClass's login function
	$uid=$userClass->userLogin($usernameEmail,$usernameEmail,$password);
	
	//If a user id is returned, user has successfully been logged in
	//  and should be redirected to the homepage
	if($uid) {
	    $url='home.php';
	    header("Location: $url");
	} else {
	    //Otherwise display an error message
	    $errorMsgLogin="Please check login details.";
	}
    }
}

//If the user has submitted sign up details
if (!empty($_POST['signupSubmit'])) {
    //Get the username, email, password, and reentered password
    $username=$_POST['usernameReg'];
    $email=$_POST['emailReg'];
    $password=$_POST['passwordReg'];
    $passwordReenter=$_POST['passwordRegReenter'];

    //Check username, email, and password against regular expressions
    //Username should be between 3 and 20 characters and
    //	may contain any uppercase/lowercase letters, numbers, and/or underscore
    $username_check = preg_match('~^[A-Za-z0-9_]{3,20}$~i', $username);

    //Email must have letters, numbers, dots, underscores, and/or dashes
    //	followed by @ followed by a dot (.) followed by 2-4 letters
    $email_check = preg_match('~^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.([a-zA-Z]{2,4})$~i', $email);

    //Password must be between 6 and 20 characters and may contain
    // uppercase/lowercase letters, numbers, and a number of symbols: !@#$%^&*()_
    $password_check = preg_match('~^[A-Za-z0-9!@#$%^&*()_]{6,20}$~i', $password);

    //If all regular expression checks pass, attempt user registration
    if($username_check && $email_check && $password_check) {
	$uid=$userClass->userRegistration($username,$password,$email);
	
	//If a user id is returned, registration was successful and user should be
	//  redirected to the homepage
	if($uid) {
	    $url='home.php';
	   header("Location: $url");
	} else {
	    //Otherwise display message indicating failure
	    $errorMsgReg="Username or Email already exists.";
	}
    } else if (strlen(trim($username))<3) {
	$errorMsgReg="Username must be between 3 and 30 characters.";
    } else if (!$email_check) {
	$errorMsgReg="You must enter a valid email address";
    } else if (strlen(trim($password))<6 || strlen(trim($password))>20) {
	$errorMsgReg="Password must be at least 6 characters.";
    } else if (strcmp($password, $passwordReenter) != 0) {
	$errorMsgReg="Passwords must match.";
    }
}

?>
<!DOCTYPE html>
<html>
    <head>
    <style>
	#container{width: 700px}
	#login,#signup{width: 300px; border: 1px solid #d6d7da; padding: 0px 15px 15px 15px; border-radius: 5px;font-family: arial; line-height: 16px;color: #333333; font-size: 14px; background: #ffffff;rgba(200,200,200,0.7) 0 4px 10px -1px}
	#login{float:left;}
	#signup{float:right;}
	h3{color:#365D98}
	form label{font-weight: bold;}
	form label, form input{display: block;margin-bottom: 5px;width: 90%}
	form input{ border: solid 1px #666666;padding: 10px;border: solid 1px #BDC7D8; margin-bottom: 20px}
	
	.button {
	    background-color: #5fcf80 !important;
	    border-color: #3ac162 !important;
	    font-weight: bold;
	    padding: 12px 15px;
	    max-width: 100px;
	    color: #ffffff;
	}

	.errorMsg{color: #cc0000;margin-bottom: 10px}
    </style>

    <title>Planner Login and Registration</title>
    <body>
	<div id="container">
	    <div id="login">
		<h3>Login</h3>
		<form method="post" action="" name="login">
		    <label>Username or Email</label>
		    <input type="text" name="usernameEmail" autocomplete="off" autofocus />
		    <label>Password</label>
		    <input type="password" name="password" autocomplete="off"/>
		    <div class="errorMsg"><?php echo $errorMsgLogin; ?></div>
		    <input type="submit" class="button" name="loginSubmit" value="Login">
	        </form>
	    </div>

	    <div id="signup">
		<h3>Registration</h3>
		<form method="post" action="" name="signup">
		    <label>Username</label>
		    <input type="text" name="usernameReg" autocomplete="off" />
		    <label>Email</label>
		    <input type="text" name="emailReg" autocomplete="off" />
		    <label>Password</label>
		    <input type="password" name="passwordReg" autocomplete="off"/>
		    <label>Re-Enter Password</label>
		    <input type="password" name="passwordRegReenter" autocomplete="off"/>
		    <div class="errorMsg"><?php echo $errorMsgReg; ?></div>
		    <input type="submit" class="button" name="signupSubmit" value="Signup">
		</form>
	    </div>

	</div>

    </body>
</html>
