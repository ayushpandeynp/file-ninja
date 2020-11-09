<?php
error_reporting(0);

$image = $_FILES['image'];
$token_id = htmlentities(addslashes($_POST["token_id"]));

if ($image["size"] == 0 || $token_id == "") {
 die("failure");
}

$fileExtension = strtolower(pathinfo($image['name'], PATHINFO_EXTENSION));
$directory = "images/upload/";

if (!file_exists($directory)) {
    mkdir($directory, 0777, true);
}

$directory_url = "https://fileninja.tk/appdata/images/upload/";

$fileName = randomFileName() . "." . $fileExtension;
$targetPath = $directory . $fileName;

while (file_exists($targetPath)) {
    $fileName = randomFileName() . "." . $fileExtension;
    $targetPath = $directory . $fileName;
}

if ($fileExtension != "jpg" && $fileExtension != "jpeg" && $fileExtension != "png") {
    die("failure");
}

$uploadStatus = 0;
if (move_uploaded_file($image["tmp_name"], $targetPath)) {
    $uploadStatus = 1;
} else {
    die("failure");
}

$image_url = $directory_url . $fileName;

$success = 0;
if($uploadStatus == 1){
    require_once("connect.php");
    $queryString = "INSERT INTO files (token_id, file_url, timestamp) VALUES('".$token_id."', '".$image_url."', NOW())";
    $query = mysqli_query($conn, $queryString);

    if($query){
        echo "success";
    }else{
        echo "failure";
    }
}else{
    echo "failure";
}

function randomFileName($length = 20)
{
    $characters = '0123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ';
    $charlen = strlen($characters);

    $randomFile = '';
    for ($i = 0; $i < $length; $i++) {
        $randomFile .= $characters[rand(0, $charlen - 1)];
    }
    return $randomFile;
}
?>