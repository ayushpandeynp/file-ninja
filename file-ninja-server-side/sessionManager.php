<?php

require_once("connect.php");

$exists = TRUE;
while($exists){
	$session_id = random_session_id();
	$queryString = "SELECT * FROM files WHERE token_id = '" . $session_id . "'";
	$query = mysqli_query($conn, $queryString);
	if(mysqli_num_rows($query) == 0){
		$exists = FALSE;
	}
}

echo $session_id;
mysqli_close($conn);

function random_session_id($length = 6){
	$characters = '0123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ';
    $charlen = strlen($characters);

    $randomSession = '';
    for ($i = 0; $i < $length; $i++) {
        $randomSession .= $characters[rand(0, $charlen - 1)];
    }
    return $randomSession;
}
?>