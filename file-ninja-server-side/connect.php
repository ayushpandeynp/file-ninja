<?php
error_reporting(0);

// hidden for security reasons
$server = "SECRET_SERVER";
$username = "SECRET_USERNAME";
$password = "SECRET_PASSWORD";
$db = "SECRET_DATABASE_NAME";

date_default_timezone_set('Asia/Karachi');
$conn = mysqli_connect($server, $username, $password, $db);

if (!$conn) {
    die("Connection Failed.");
}

mysqli_set_charset($conn, "utf8");
?>