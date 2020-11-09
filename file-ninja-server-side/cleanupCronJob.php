<?php

// CRON-JOB SCRIPT THAT RUNS EVERY MINUTE
// ON THE SERVER

require_once("connect.php");

$queryString = "SELECT * FROM files ORDER BY timestamp DESC";
$query = mysqli_query($conn, $queryString);

$files = array();

$count = 0;
while($row = mysqli_fetch_assoc($query)){
    $time = $row["timestamp"];
    $minutesPassed = (int) (time() - strtotime($time)) / 60;

    $filePath = getPathFromURL($row["file_url"]);
    if($minutesPassed >= 30){
        if(file_exists($filePath)){
            unlink($filePath);
            $count++;
        }

        $fileNameString = pathinfo($filePath, PATHINFO_FILENAME);
        $fileExtension = pathinfo($filePath, PATHINFO_EXTENSION);
    
        $compressed1 = "images/upload/" . $fileNameString . "compressed" . "." . $fileExtension;
        $compressed2 = "images/upload/" . $fileNameString . "compressedcompressed" . "." . $fileExtension;

        if(file_exists($compressed1)){
            unlink($compressed1);
            $count++;
        }
        if(file_exists($compressed2)){
            unlink($compressed2);
            $count++;
        }
    }
}

if($count > 0){
    echo $count . " files deleted.\n";
}
mysqli_close($conn);

function getPathFromURL($url){
    $parsed = parse_url($url, PHP_URL_PATH);
    return "images/upload/" . basename($parsed);
}

?>