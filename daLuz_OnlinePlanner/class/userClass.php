<?php
class userClass
/*
All code edited to reflect our own database attributes,
    in addition to other changes as noted below.
*/
{
    /* User Login */
    public function userLogin($username,$email,$password)
    {
	$db = getDB();
        $hash_password= hash('sha256', $password);
        
	//Edited to check without case sensitivity
	$stmt = $db->prepare("SELECT clientid FROM client WHERE UPPER(username)=UPPER(:user) AND  passwordhash=:hash_password");  
	$stmt->bindParam("user", $username,PDO::PARAM_STR);
        $stmt->bindParam("hash_password", $hash_password,PDO::PARAM_STR);
	$stmt->execute();
        
	$count=$stmt->rowCount();
        $data=$stmt->fetch(PDO::FETCH_OBJ);
        $db = null;
        
	if($count) {
	    $_SESSION['uid']=$data->clientid;
            return true;
        } else {
            return false;
        }    
    }

    /* User Registration */
    public function userRegistration($username,$password,$email)
    {
	try{
	    $db = getDB();
	    //Edited to check without case sensitivity
	    $st = $db->prepare("SELECT clientid FROM client WHERE UPPER(username)=UPPER(:username)");  
	    $st->bindParam("username", $username,PDO::PARAM_STR);
	    //$st->bindParam("email", $email,PDO::PARAM_STR);
	    $st->execute();
	    $count=$st->rowCount();
          
	    if($count<1) {
		$stmt = $db->prepare("INSERT INTO client(username,passwordhash,email) VALUES (:username,:hash_password,:email)");  
	        $stmt->bindParam("username", $username,PDO::PARAM_STR) ;
		$hash_password = hash('sha256', $password);
		$stmt->bindParam("hash_password", $hash_password,PDO::PARAM_STR) ;
		$stmt->bindParam("email", $email,PDO::PARAM_STR) ;
		$stmt->execute();

		$uid=$db->lastInsertId();
		$db = null;
		
		$_SESSION['uid']=$uid;
		
		return true;
	    } else {
		$db = null;
		return false;
	    }
	} catch(PDOException $e) {
          echo '{"error":{"text":'. $e->getMessage() .'}}'; 
        }
    }
     
    /* User Details */
    public function userDetails($uid)
    {
	try{
	    $db = getDB();
	    $stmt = $db->prepare("SELECT username,email FROM client WHERE client.clientid=:uid");  
	    $stmt->bindParam("uid", $uid,PDO::PARAM_INT);
	    $stmt->execute();
	    $data = $stmt->fetch(PDO::FETCH_OBJ);
          
	    return $data;
	} catch(PDOException $e) {
	    echo '{"error":{"text":'. $e->getMessage() .'}}'; 
	}
    }
}
?>
