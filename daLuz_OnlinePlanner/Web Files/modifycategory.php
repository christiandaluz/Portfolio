<?php
include('config.php');
include('session.php');
$userDetails=$userClass->userDetails($session_uid);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Modify Category</title>
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

	//Select the category from the database
        $st = $dbh->prepare("
            SELECT DISTINCT * FROM category
            WHERE $session_uid=category.clientid
            AND catid={$_GET['categoryid']}
        ");
        $st->execute();

        $row = $st->fetch();

	//If nothing is returned, the category either doesn't exist or does
	//  not belong to the user
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
                <h3>Modify "<?php echo $row['catname']; ?>"</h3>
                <form method="post" action="" name="modifycategory">
                    <label>Category Name</label>
                    <input type='text' name='catname' value="<?php echo $row['catname']; ?>" autocomplete='off' required />
                    </br>

		    <?php
			print "<input type='submit' class='button' name='categorySubmit' value='Confirm Modification'>";
		    ?>    

               </form>
            </div>

            <div class="delete">
                <form method="post" action="deletecategory.php?categoryid=<?php echo $row['catid']; ?>" name="deletecategory">
                <input type='submit' class='button' name='deleteCatSubmit' value='Delete Category (Action cannot be undone)'>
		</form>
            </div>
	</div>

	<?php
            try {
                $dbh = new PDO('pgsql:dbname=ssplanner');

		//Prepare the update statement
                if (isset($_REQUEST['catname'])) {
                    $update = $dbh->prepare("
                        UPDATE category
                        SET catname=?
                        WHERE catid=?
                        ");

                    $update->bindParam(1, $_REQUEST['catname']);
		    $update->bindParam(2, $row['catid']);

		    //Attempt to execute the update; if successful, redirect to agenda
                    if ($update->execute()) {
                        print "<h1>Category '{$_REQUEST['catname']}' modified successfully.</h1>";
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

